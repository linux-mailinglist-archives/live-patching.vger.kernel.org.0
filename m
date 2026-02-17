Return-Path: <live-patching+bounces-2029-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AJI5KueTlGl3FgIAu9opvQ
	(envelope-from <live-patching+bounces-2029-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:14:31 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D3C14DF21
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 17:14:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B186300C980
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 16:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7416336E463;
	Tue, 17 Feb 2026 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ny/ugYH4"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17785359FB0
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 16:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771344869; cv=none; b=FtN4QgVNOfx2HUXa2+xmIGpfEEFZbVVWFceCX7ZK61xYNqdalf1K/j0eAMJncgCJBwH1Y/iuNY54UEmDKQDUT3POvZP4es9Be8IDp6RqfkDpNp4Ozo2gFs9I00VwRRMUasQqNuz9lj/oT+IYF/bUOvvc0CEDuNJyvUXoqy/jBDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771344869; c=relaxed/simple;
	bh=b9uaKD7/cNwjJ42ozZid+c4HEgm0oIaObedBRIbBun8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5CVPMt2TTB2sV76tReV/f0IE7Qzo5yxKGc2SRzFX9aJsvNuZlXcnN/x2XFcvgPfaRKVZGq8ZRu6YVX7ez9KuaRmyAkKvapTAOEjpw22wTvyYgZbrGUdIB4kCNkRhGjdNOo9JgTcUd8+ymctKw6hsxfyiyklLFcaxJYl7ntIe/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ny/ugYH4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771344867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t+ANvB+QZ1X0gmmdL/ji2aDIct+JPKq7A+h+Qg8jrR8=;
	b=Ny/ugYH4R7TmrN905+3T7NDCgak6oaYskoSCz2WVFF3e/CZyiI0W1XGsa1mOrflKRXaWEG
	BPz/EQPN3Axnv9zCwY7e182x4DCcbXej39AYstMQm/iI5hrzZQAx+gNY4EKWcDCKHjvWwH
	PuCw/RgaN/4lAFgBJCVw/JshVhsVyIQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-O3wyOGDsNS-WNdecE0NLPQ-1; Tue,
 17 Feb 2026 11:14:22 -0500
X-MC-Unique: O3wyOGDsNS-WNdecE0NLPQ-1
X-Mimecast-MFC-AGG-ID: O3wyOGDsNS-WNdecE0NLPQ_1771344861
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AEB2A1954B12;
	Tue, 17 Feb 2026 16:14:21 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8785E19560A2;
	Tue, 17 Feb 2026 16:14:20 +0000 (UTC)
Date: Tue, 17 Feb 2026 11:14:17 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 01/13] objtool/klp: honor SHF_MERGE entry alignment in
 elf_add_data()
Message-ID: <aZST2WmYD-B_o0oc@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-2-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217160645.3434685-2-joe.lawrence@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2029-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 23D3C14DF21
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 11:06:32AM -0500, Joe Lawrence wrote:
> When adding data to an SHF_MERGE section, set the Elf_Data d_align to
> the section's sh_addralign so libelf aligns entries within the section.
> This ensures that entry offsets are consistent with previously calculated
> relocation addends.
> 
> Fixes: 431dbabf2d9d ("objtool: Add elf_create_data()")
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
>  tools/objtool/elf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> index 2c02c7b49265..bd6502e7bdc0 100644
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
> @@ -1375,7 +1375,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
>  		memcpy(sec->data->d_buf, data, size);
>  
>  	sec->data->d_size = size;
> -	sec->data->d_align = 1;
> +	sec->data->d_align = (sec->sh.sh_flags & SHF_MERGE) ? sec->sh.sh_addralign : 1;
>  
>  	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
>  	sec->sh.sh_size = offset + size;
> -- 
> 2.53.0
> 
> 

This one stretches my ELF internals knowledge a bit, is ^^ true or
should we rely on the section ".str1.8" suffix to indicate internal
alignment?

Here is the repro:

A simple patch to pr_info a few strings to the kernel buffer:

  diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
  index a6f76121955f..5b7f43105ea8 100644
  --- a/fs/proc/cmdline.c
  +++ b/fs/proc/cmdline.c
  @@ -7,6 +7,10 @@

   static int cmdline_proc_show(struct seq_file *m, void *v)
   {
  +	pr_info("ABCDEFGHIJKLMN:   message 1 here\n");
  +	pr_info("OPQRSTUVWXYZ12:   message 2 here\n");
  +	pr_info("34567890abcdef:   message 3 here\n");
  +	pr_info("ghijklmnopqrst:   message 4 here\n");
   	seq_puts(m, saved_command_line);
   	seq_putc(m, '\n');
   	return 0;

results in strange dmesg output:

  [ 6179.571413] ABCDEFGHIJKLMN:   message 1 here
  [ 6179.575689] QRSTUVWXYZ12:   message 2 here
  [ 6179.579788] 90abcdef:   message 3 here
  [ 6179.583541] qrst:   message 4 here

patched/vmlinux.o
-----------------

First thing to note, section .rodata.cmdline_proc_show.str1.8 has
entries with an alignment of 8 bytes and the section is SHF_MERGE:

  $ readelf --wide -S klp-tmp/patched/vmlinux.o
  Section Headers:
  [Nr]      Name                              Type      Address           Off      Size    ES  Flg  Lk  Inf  Al
  [132261]  .rodata.cmdline_proc_show.str1.8  PROGBITS  0000000000000000  23b3000  00009c  01  AMS  0   0    8

  $ eu-objdump -r -j .rela.text.unlikely.cmdline_proc_show klp-tmp/patched/vmlinux.o | grep str1.8
  0000000000000020 R_X86_64_32S         .rodata.cmdline_proc_show.str1.8
  000000000000002c R_X86_64_32S         .rodata.cmdline_proc_show.str1.8+0x28
  0000000000000038 R_X86_64_32S         .rodata.cmdline_proc_show.str1.8+0x50
  0000000000000044 R_X86_64_32S         .rodata.cmdline_proc_show.str1.8+0x78

  $ eu-objdump -s -j .rodata.cmdline_proc_show.str1.8 klp-tmp/patched/vmlinux.o
  klp-tmp/patched/vmlinux.o: elf64-elf_x86_64

  Contents of section .rodata.cmdline_proc_show.str1.8:
   0000 01364142 43444546 4748494a 4b4c4d4e  .6ABCDEFGHIJKLMN
        ^ (+0x00)                            ^
   0010 3a202020 6d657373 61676520 31206865  :   message 1 he
   0020 72650a00 00000000 01364f50 51525354  re.......6OPQRST
                          ^ (+0x28)                  ^
   0030 55565758 595a3132 3a202020 6d657373  UVWXYZ12:   mess
   0040 61676520 32206865 72650a00 00000000  age 2 here......
   0050 01363334 35363738 39306162 63646566  .634567890abcdef
        ^ (+0x50)                            ^
   0060 3a202020 6d657373 61676520 33206865  :   message 3 he
   0070 72650a00 00000000 01366768 696a6b6c  re.......6ghijkl
                          ^ (+0x78)                  ^
   0080 6d6e6f70 71727374 3a202020 6d657373  mnopqrst:   mess
   0090 61676520 34206865 72650a00           age 4 here..


diff/vmlinux.o
--------------

Same 8-byte alignment of .rodata.cmdline_proc_show.str1.8:

  $ readelf --wide -S klp-tmp/diff/vmlinux.o | grep str1.8
  Section  Headers:
  [Nr]  Name                              Type      Address           Off     Size    ES  Flg  Lk  Inf  Al
  [6]   .rodata.cmdline_proc_show.str1.8  PROGBITS  0000000000000000  000540  000090  01  AMS  0   0    8

  $ eu-objdump -r klp-tmp/diff/vmlinux.o | grep str1.8
  0000000000000020 R_X86_64_32S         .rodata.cmdline_proc_show.str1.8
  000000000000002c R_X86_64_32S         .rodata.cmdline_proc_show.str1.8+0x28
  0000000000000038 R_X86_64_32S         .rodata.cmdline_proc_show.str1.8+0x50
  0000000000000044 R_X86_64_32S         .rodata.cmdline_proc_show.str1.8+0x78

but notice they do not point to the strings in a now packed section
contents:

  $ eu-objdump -s -j .rodata.cmdline_proc_show.str1.8 klp-tmp/diff/vmlinux.o
  klp-tmp/diff/vmlinux.o: elf64-elf_x86_64

  Contents of section .rodata.cmdline_proc_show.str1.8:
   0000 01364142 43444546 4748494a 4b4c4d4e  .6ABCDEFGHIJKLMN
        ^ (+0x00)                            ^
   0010 3a202020 6d657373 61676520 31206865  :   message 1 he
   0020 72650a00 01364f50 51525354 55565758  re...6OPQRSTUVWX
                          ^ (+0x28)                  ^
   0030 595a3132 3a202020 6d657373 61676520  YZ12:   message
   0040 32206865 72650a00 01363334 35363738  2 here...6345678
   0050 39306162 63646566 3a202020 6d657373  90abcdef:   mess
        ^ (+0x50)                            ^
   0060 61676520 33206865 72650a00 01366768  age 3 here...6gh
   0070 696a6b6c 6d6e6f70 71727374 3a202020  ijklmnopqrst:
                          ^ (+0x78)                  ^
   0080 6d657373 61676520 34206865 72650a00  message 4 here..

--
Joe


