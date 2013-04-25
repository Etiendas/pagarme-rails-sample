require 'pagarme'

class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  # POST /transactions
  # POST /transactions.json
  def create
	pagarme_transaction = PagarMe::Transaction.new(params[:card_hash])
    @transaction = Transaction.new(params[:transaction])

	pagarme_transaction.amount = @transaction.amount

	begin
	  pagarme_transaction.charge
	rescue PagarMe::PagarMeError => e
	  puts e.inspect
	  redirect_to new_transaction_path, notice: "Erro: #{e.message}" 
	  return
	end

	@transaction.transaction_id = pagarme_transaction.id
	@transaction.status = pagarme_transaction.status.to_s

    # respond_to do |format|
      if @transaction.save
        redirect_to transactions_path, notice: 'Transaction was successfully created.'
        # format.json { render json: @transaction, status: :created, location: @transaction }
      else
        render action: "new"
      end
    # end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = Transaction.find(params[:id])
	pagarme_transaction = PagarMe::Transaction.find_by_id(@transaction.transaction_id)

	puts pagarme_transaction.inspect

	begin
	  pagarme_transaction.chargeback
	rescue PagarMe::PagarMeError => e
	  redirect_to transactions_path, notice: "Erro: #{e.message}" 
	  return
	end

	@transaction.status = pagarme_transaction.status.to_s
	@transaction.save

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end
end
