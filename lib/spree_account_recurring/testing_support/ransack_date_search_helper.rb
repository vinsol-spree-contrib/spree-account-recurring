shared_examples 'ransack_date_search' do |controller_klass, klass, opts|
  def send_request(params={q: {}})
    spree_get :index, params
  end

  describe 'class_method ransack_date_searchable' do
    context 'when options passed in hash' do
      describe 'define and set class attribute' do
        context 'when date_col is passed as option' do
          before(:each) do
            controller_klass.ransack_date_searchable(date_col: opts[:date_col])
          end

          it { controller_klass.ransack_date_search_config.should eq({date_col: opts[:date_col]}) }
          it { controller_klass.ransack_date_search_col_ref.should eq(opts[:date_col]) }
          it { controller_klass.ransack_date_search_param_gt.should eq("#{opts[:date_col]}_gt") }
          it { controller_klass.ransack_date_search_param_lt.should eq("#{opts[:date_col]}_lt") }
        end

        context 'when date_col is not passed as option' do
          before(:each) do
            controller_klass.ransack_date_searchable
          end

          it { controller_klass.ransack_date_search_config.should eq({date_col: 'created_at'}) }
          it { controller_klass.ransack_date_search_col_ref.should eq('created_at') }
          it { controller_klass.ransack_date_search_param_gt.should eq("created_at_gt") }
          it { controller_klass.ransack_date_search_param_lt.should eq("created_at_lt") }
        end
      end
    end
  end

  it 'should receive parse_ransack_date_search_param!' do
    controller.should_receive(:parse_ransack_date_search_param!)
    send_request
  end

  describe '#parse_ransack_date_search_param!' do
    let(:time1) { Time.now }
    let(:time2) { Time.now - 1.days }
    let(:time3) { Time.now + 1.days }

    before(:each) do
      @ransack_obj = klass.ransack
      Time.stub_chain(:current, :beginning_of_month).and_return(time1)
      Time.stub_chain(:zone, :parse, :beginning_of_day).and_return(time2)
      Time.stub_chain(:zone, :parse, :end_of_day).and_return(time3)
    end

    context 'when params q not present' do
      context 'when params[ransack_date_search_param_gt] present' do
        let(:params) { {q: {"#{opts[:date_col]}_gt" => "11/11/11"}} }

        context 'when params[ransack_date_search_param_gt] gives error' do
          before(:each) do
            Time.stub_chain(:zone, :parse, :beginning_of_day).and_raise(StandardError)
          end

          it { klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
        end

        context 'when params[ransack_date_search_param_gt] do not gives error' do
          before(:each) do
            Time.stub_chain(:zone, :parse, :beginning_of_day).and_return(time2)
          end

          it { klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time2, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
        end
      end

      context 'when params[ransack_date_search_param_gt] is not present' do
        let(:params) { {q: {}} }

        it { klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
      end

      context 'when params[ransack_date_search_param_lt] present' do
        let(:params) { {q: {"#{opts[:date_col]}_lt" => '14/11/11'}} }

        context 'when params[ransack_date_search_param_lt] gives error' do
          before(:each) do
            Time.stub_chain(:zone, :parse, :end_of_day).and_raise(StandardError)
          end

          it { klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
        end

        context 'when params[ransack_date_search_param_lt] do not gives error' do
          before(:each) do
            Time.stub_chain(:zone, :parse, :end_of_day).and_return(time3)
          end

          it { klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "#{opts[:date_col]}_lt" => time3, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
        end
      end

      context 'when params[ransack_date_search_param_lt] is not present' do
        let(:params) { {q: {}} }

        it { klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
      end
    end

    context 'when params[q][s] is present' do
      let(:params) {{q: {s: "#{opts[:date_col]} asc"}}}

      it {klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "s"=>"#{opts[:date_col]} asc"}).and_return(@ransack_obj) }
    end

    context 'when params[q][s] is not present' do
      let(:params) {{q: {}}}

      it {klass.should_receive(:ransack).with({"#{opts[:date_col]}_gt" => time1, "s"=>"#{opts[:date_col]} desc"}).and_return(@ransack_obj) }
    end

    after(:each) do
      send_request(params)
    end
  end

  after(:each) do
    controller_klass.ransack_date_searchable(opts)
  end
end