//! qtcloud-meta CLI 入口。参数解析在这一层，范畴分析的实现在库里。

use clap::{Parser, Subcommand};
use qtcloud_meta_cli::category::within::{self, Options};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "qtcloud-meta", about = "量潮元数据 CLI")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// 范畴分析
    Category {
        #[command(subcommand)]
        sub: CategoryCommands,
    },
}

#[derive(Subcommand)]
enum CategoryCommands {
    /// 范畴内分析：装载 → 分析 → 返回
    Within {
        /// 范畴标识符
        category: String,
        /// 输出格式：md 或 json
        #[arg(long, default_value = "md")]
        format: String,
        /// 输出文件路径，缺省打印到 stdout
        #[arg(long)]
        out: Option<PathBuf>,
        /// 严格模式：任一公理失败即非零退出
        #[arg(long)]
        strict: bool,
    },
}

fn main() -> std::process::ExitCode {
    let cli = Cli::parse();
    match cli.command {
        Commands::Category { sub } => match sub {
            CategoryCommands::Within {
                category,
                format,
                out,
                strict,
            } => {
                let options = Options {
                    format,
                    out,
                    strict,
                };
                match within::run(&category, &options) {
                    Ok(()) => std::process::ExitCode::SUCCESS,
                    Err(message) => {
                        eprintln!("错误：{message}");
                        std::process::ExitCode::FAILURE
                    }
                }
            }
        },
    }
}
