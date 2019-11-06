Channel
	.fromPath("${params.sras}")
	.splitCsv(header: false, strip: true)
	.map { line -> line[0] }
	//.take(1)
	.into { sras }



process sra2fastq{
	
	tag { "" }

	memory 32.GB

	input:
	val sraid from sras

	script:
	"""

	mkdir -p /efs/dbGaP-fastq/${sraid}

	/opt/sratoolkit.2.9.6-ubuntu64/bin/vdb-config --import /efs/prj_23096.ngc
	
	cd /root/ncbi/dbGaP-23096

	/opt/sratoolkit.2.9.6-ubuntu64/bin/fastq-dump -I --split-files ${sraid} -O /efs/dbGaP-fastq/${sraid}

	/root/anaconda3/bin/aws s3 cp /efs/dbGaP-fastq/${sraid}/  s3://bioinformatics-analysis/dbGaP-23096/ --recursive
	"""
}
