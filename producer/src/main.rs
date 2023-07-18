use chrono::prelude::*;
use lapin::{options::*, Connection, ConnectionProperties, message::BasicGetMessage, types::FieldTable};
use futures::executor::block_on as wait;
use flate2::write::GzEncoder;
use flate2::Compression;
use std::io::prelude::*;
use std::fs::OpenOptions;

fn main() {
    let addr = std::env::var("RABBITMQ_SERVER").unwrap();
    let conn = wait(Connection::connect(&addr, ConnectionProperties::default())).expect("connection error");
    let channel = wait(conn.create_channel()).expect("create_channel error");

    wait(channel.queue_declare("adsb", QueueDeclareOptions::default(), FieldTable::default())).expect("queue_declare error");

    loop {
        let get_msg: Option<BasicGetMessage> = wait(channel.basic_get("adsb", BasicGetOptions::default())).expect("basic_get error");

        if let Some(get_msg) = get_msg {
            let delivery = get_msg.delivery;
            let date = Local::now().format("%Y%m%d").to_string();
            let file_name = format!("/data/adsb-log_{}.csv.gz", date);
            let f = OpenOptions::new().append(true).create(true).open(&file_name).expect("Unable to open file");
            let mut gz = GzEncoder::new(f, Compression::default());
            gz.write_all(&delivery.data).expect("Unable to write data");
            wait(channel.basic_ack(delivery.delivery_tag, BasicAckOptions::default())).expect("basic_ack error");
        }
    }
}
