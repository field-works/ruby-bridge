require 'spec_helper'

RSpec.describe FieldReports do
  it "Ruby Bridgeのバージョンが取得できる" do
    expect(FieldReports::VERSION).not_to be nil
  end

  describe "Bridge" do
    before do
      @reports = FieldReports::Bridge.create_proxy()
    end

    it "Field Reportsのバージョンが取得できる" do
      expect(@reports.version[0,2]).to eq "2."
    end

    it "JSON文字列を元にPDFを生成できる" do
      param = <<EOS
        {
          "template": {"paper": "A4"},
          "context": {
            "hello": {
              "new": "Tx",
              "value": "Hello, World!",
              "rect": [100, 700, 400, 750]
            }
          }
        }
EOS
      pdf = @reports.render(param)
      expect(pdf[0,8]).to eq "%PDF-1.6"
      expect(pdf[-6,5]).to eq "%%EOF"
    end

    it "ハッシュ形式パラメータを元にPDFを生成できる" do
      param = {
        "template": {"paper": "A4"},
        "context": {
          "hello": {
            "new": "Tx",
            "value": "Hello, World!",
            "rect": [100, 700, 400, 750]
          }
        }
      }
      pdf = @reports.render(param)
      expect(pdf[0,8]).to eq "%PDF-1.6"
      expect(pdf[-6,5]).to eq "%%EOF"
    end

    it "パースエラーで例外が発生する" do
      expect do
        pdf = @reports.render("{,}")
      end.to raise_error(FieldReports::ReportsError)
    end

    it "PDFデータを解析できる" do
      pdf = File.binread("spec/mitumori.pdf")
      result = @reports.parse(pdf)
      expect(result["template"]).not_to eq nil
      expect(result["xyz"]).to eq nil
    end
  end
end
