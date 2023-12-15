#!/usr/bin/env cargo +nightly -Zscript 

// mostly ripped from Chris Biscardi's AOC template.

    //! ```cargo
    //! [package]
    //! edition = "2021"
    //! 
    //! [dependencies]
    //! dotenv = "*"
    //! clap = { version = "*", features = ["derive"] }
    //! nom = "*"
    //! reqwest = { version = "*", features=["blocking"] }
    //! ```

use dotenv::dotenv;
use clap::{error::ErrorKind, CommandFactory, Parser};
use nom::{
    bytes::complete::tag, character::complete,
    sequence::preceded, IResult,
};
use reqwest::{{blocking::Client, header::COOKIE}};
use std::fs::File;
use std::io::Write;
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[clap(version)]
struct Args {
    /// day is expected to be formatted as day01
    #[clap(short, long)]
    day: String,
    
    // pass in the justfile directory so we're always in the root
    #[clap(long)]
    current_working_directory: PathBuf,
}

fn parse_day(input: &str) -> IResult<&str, u32> {
    preceded(tag("day"), complete::u32)(input)
}

fn main() -> Result<(), reqwest::Error> {
    dotenv().expect(".env file not found");
    let session = std::env::var("SESSION")
        .expect("You need to define the SESSION environment val. Get this from your authentication session cookie on adventofcode.com");
    let args = Args::parse();
    let Ok((_, day)) = parse_day(&args.day) else {
        let mut cmd = Args::command();
        cmd.error(
            ErrorKind::ValueValidation,
            format!(
                "day `{}` must be formatted as `day01`",
                args.day
            ),
        )
        .exit();
    };

    let url = format!("https://adventofcode.com/2023/day/{day}/input");
    println!("sending to `{url}`");

    let client = Client::new();
    let input_data = client.get(url)
        .header(COOKIE, format!("session={session}"))
        .send()?
        .text()?;

    for filename in ["input1.txt", "input2.txt"] {
        let file_path = args.current_working_directory
            .join(&args.day)
            .join(filename);
        let mut file = File::create(&file_path).expect("file create error");
        file.write_all(input_data.as_bytes()).expect("file write error");
        println!("Wrote to {}", file_path.display());
    }
    
    Ok(())
}
