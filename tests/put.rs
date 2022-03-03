use std::str::FromStr;
use mongodb::{options::{ClientOptions, ServerAddress}, Client};
use serde::{Serialize,Deserialize};

#[derive(Serialize,Deserialize,Debug)]
struct Item {
   name: String,
}

#[tokio::test]
async fn put() -> anyhow::Result<()> {

    let addr: Vec<ServerAddress> = ["localhost:30001", "localhost:30002", "localhost:30003"].into_iter().map(|addr| ServerAddress::from_str(addr).unwrap()).collect();

    let opt = ClientOptions::builder()
        .hosts(addr)
        .repl_set_name("replica-set".to_owned())
        .build();

    let client = Client::with_options(opt)?;

    let db = client.database("app");
    let collection = db.collection::<Item>("Item");

    let item = Item { name: String::from("item-1")};
    let insert_result = collection.insert_one(item,None).await?;
    println!("{:#?}", insert_result);

    Ok(())
}
