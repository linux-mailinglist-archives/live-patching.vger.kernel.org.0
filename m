Return-Path: <live-patching+bounces-2164-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cDrYHYI4sGkKhQIAu9opvQ
	(envelope-from <live-patching+bounces-2164-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 16:28:02 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A59C2537C1
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 16:28:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8493D31B65FD
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 14:04:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A97399373;
	Tue, 10 Mar 2026 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hlofpfYZ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21999399364
	for <live-patching@vger.kernel.org>; Tue, 10 Mar 2026 14:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773151392; cv=none; b=C5CETDBoXAyhJG00QBNPBCXqZXHZBfnJwQhtvFAeZTG4fX99UKWybd2zRDkuVLS0obQU94R6oHjnOdhrZA/agoXvvrS5NvmuvP8mo11I+lA1OPtF3U50Kyi1Tu2tlnWes2yvuJyxb7ZKZ0q3a92NThYfdo+8liTCH0udBHuLLjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773151392; c=relaxed/simple;
	bh=SF5tMh6oXJ1dFnFMoa1VtMedr6NPqYz0Q6jL4ZBsdQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0P9gQbTW4bOPWepNgoLGm2q44jTZGane+BxYYbdFYlAddqjaIgRTFQSfHKn2t5jniT3JMAGL7FVwYTDB0DpHIvKzSAVKrzHZySh80HBZpS+rIzTomVxsrEbzGhUVsAHm/8cTgZ2zk+s5LNpiXLo78TaMvPzyB6qZu6K9o+wn2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hlofpfYZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773151389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ERmRGefaQkHm8qCRGRQOxO0ZJ0LtQZmzofu0vLeuIaw=;
	b=hlofpfYZudsRY+savE1J6YMxEBwb/BHxvRFKpUzi30fF3Blk0WT0IM1FLaEYp37ZnVw/E6
	ycYtxPrHcTIQAXiJ3Ik25MOwahzZ4bFhlWcgKNGV0CMwiA9LwcqAgLmzAkVTzPJ+oOoSVS
	YseRA+seBlKeZ+wRgCLgq72f3zztyaQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-754DEDk6OLqwv6E3j6Tskw-1; Tue,
 10 Mar 2026 10:03:03 -0400
X-MC-Unique: 754DEDk6OLqwv6E3j6Tskw-1
X-Mimecast-MFC-AGG-ID: 754DEDk6OLqwv6E3j6Tskw_1773151382
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B1F618005BA;
	Tue, 10 Mar 2026 14:03:02 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.5])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F01CE1800351;
	Tue, 10 Mar 2026 14:03:00 +0000 (UTC)
Date: Tue, 10 Mar 2026 10:02:58 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 01/13] objtool/klp: honor SHF_MERGE entry alignment in
 elf_add_data()
Message-ID: <abAkkrWoTao_tIi7@redhat.com>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-2-joe.lawrence@redhat.com>
 <aZST2WmYD-B_o0oc@redhat.com>
 <p67ixebt5ufjed44j6wrufwihmsh3ufhbdog7767ro6tygleaw@lvp55v6brjxw>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p67ixebt5ufjed44j6wrufwihmsh3ufhbdog7767ro6tygleaw@lvp55v6brjxw>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Queue-Id: 7A59C2537C1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2164-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Wed, Mar 04, 2026 at 06:33:47PM -0800, Josh Poimboeuf wrote:
> On Tue, Feb 17, 2026 at 11:14:17AM -0500, Joe Lawrence wrote:
> > On Tue, Feb 17, 2026 at 11:06:32AM -0500, Joe Lawrence wrote:
> > > When adding data to an SHF_MERGE section, set the Elf_Data d_align to
> > > the section's sh_addralign so libelf aligns entries within the section.
> > > This ensures that entry offsets are consistent with previously calculated
> > > relocation addends.
> > > 
> > > Fixes: 431dbabf2d9d ("objtool: Add elf_create_data()")
> > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > ---
> > >  tools/objtool/elf.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> > > index 2c02c7b49265..bd6502e7bdc0 100644
> > > --- a/tools/objtool/elf.c
> > > +++ b/tools/objtool/elf.c
> > > @@ -1375,7 +1375,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
> > >  		memcpy(sec->data->d_buf, data, size);
> > >  
> > >  	sec->data->d_size = size;
> > > -	sec->data->d_align = 1;
> > > +	sec->data->d_align = (sec->sh.sh_flags & SHF_MERGE) ? sec->sh.sh_addralign : 1;
> > >  
> > >  	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
> > >  	sec->sh.sh_size = offset + size;
> > > -- 
> > > 2.53.0
> > > 
> > > 
> > 
> > This one stretches my ELF internals knowledge a bit, is ^^ true or
> > should we rely on the section ".str1.8" suffix to indicate internal
> > alignment?
> 
> I hit the same issue in my testing for the klp-build arm64 port, I think
> it can be simplified to the below?
> 
> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> @@ -1375,7 +1382,7 @@ void *elf_add_data(struct elf *elf, struct section *sec, const void *data, size_
>  		memcpy(sec->data->d_buf, data, size);
>  
>  	sec->data->d_size = size;
> -	sec->data->d_align = 1;
> +	sec->data->d_align = sec->sh.sh_addralign;
>  
>  	offset = ALIGN(sec->sh.sh_size, sec->sh.sh_addralign);
>  	sec->sh.sh_size = offset + size;
> 

Yeah that make sense, but I think we both missed the second half of the
fix in the symbol table.  This patch fails with your version:

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -54,6 +54,13 @@ static u64 get_iowait_time(struct kernel_cpustat *kcs, int cpu)
 	return iowait;
 }
 
+static void klp_test_stat_accessed(void)
+{
+	static atomic_t call_count = ATOMIC_INIT(0);
+	atomic_inc(&call_count);
+	pr_info("klp-build-test: stat accessed %d times\n", atomic_read(&call_count));
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -92,6 +99,7 @@ static int show_stat(struct seq_file *p, void *v)
 	user = nice = system = idle = iowait =
 		irq = softirq = steal = 0;
 	guest = guest_nice = 0;
+	klp_test_stat_accessed();
 	getboottime64(&boottime);
 	/* shift boot timestamp according to the timens offset */
 	timens_sub_boottime(&boottime);

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

Confused on instruction decoding?

  livepatch-test.o: warning: objtool: show_stat+0x696: can't find jump dest instruction at .rodata.show_stat.str1.1+0x38
  make[3]: *** [/root/linux/scripts/Makefile.build:505: livepatch-test.o] Error 255
  make[3]: *** Deleting file 'livepatch-test.o'
  make[2]: *** [/root/linux/Makefile:2064: .] Error 2
  make[1]: *** [/root/linux/Makefile:248: __sub-make] Error 2
  make: *** [Makefile:248: __sub-make] Error 2
  error: klp-build: line 793: '"${cmd[@]}" > >(tee -a "$log") 2> >(tee -a "$log" 1>&2)'
  error: klp-build: line 795: '( cd "$SRC"; "${cmd[@]}" > >(tee -a "$log") 2> >(tee -a "$log" 1>&2) )'

Notice the 0x10 section offset value for show_stat in the generated
vmlinux.o diff object symbol table:

  $ readelf --wide --symbols klp-tmp/diff/vmlinux.o | grep -E 'Ndx|\.text\.show_stat$|show_stat$|pfx_show_stat$'
     Num:    Value          Size Type    Bind   Vis      Ndx Name
       1: 0000000000000000    16 FUNC    LOCAL  DEFAULT    4 __pfx_show_stat
       2: 0000000000000010  2126 FUNC    LOCAL  DEFAULT    4 show_stat
       5: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 .text.show_stat

but then in the disassembly, show_stat() starts 0x20 bytes into the
section:

  $ objdump -d -j .text.show_stat --start-address=0x0 --stop-address=0x24 klp-tmp/diff/vmlinux.o
  
  klp-tmp/diff/vmlinux.o:     file format elf64-x86-64
  
  
  Disassembly of section .text.show_stat:
  
  0000000000000000 <__pfx_show_stat>:
     0:   90                      nop
     1:   90                      nop
     2:   90                      nop
     3:   90                      nop
     4:   90                      nop
     5:   90                      nop
     6:   90                      nop
     7:   90                      nop
     8:   90                      nop
     9:   90                      nop
     a:   90                      nop
     b:   90                      nop
     c:   90                      nop
     d:   90                      nop
     e:   90                      nop
     f:   90                      nop
  
  0000000000000010 <show_stat>:
          ...
    20:   f3 0f 1e fa             endbr64


When cloning the symbol, if we ensure the symbol's offset aligns
with the sh_addralign (as elf_add_data() does now):

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
index a3198a63c2..c2c4e4968b 100644
--- a/tools/objtool/klp-diff.c
+++ b/tools/objtool/klp-diff.c
@@ -14,6 +14,7 @@
 #include <objtool/util.h>
 #include <arch/special.h>
 
+#include <linux/align.h>
 #include <linux/objtool_types.h>
 #include <linux/livepatch_external.h>
 #include <linux/stringify.h>
@@ -560,7 +561,7 @@ static struct symbol *__clone_symbol(struct elf *elf, struct symbol *patched_sym
 		}
 
 		if (!is_sec_sym(patched_sym))
-			offset = sec_size(out_sec);
+			offset = ALIGN(sec_size(out_sec), out_sec->sh.sh_addralign);
 
 		if (patched_sym->len || is_sec_sym(patched_sym)) {
 			void *data = NULL;

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

Results are as expected:

  $ readelf --wide --symbols klp-tmp/diff/vmlinux.o | grep -E 'Ndx|\.text\.show_stat$|show_stat$|pfx_show_stat$'
     Num:    Value          Size Type    Bind   Vis      Ndx Name
       1: 0000000000000000    16 FUNC    LOCAL  DEFAULT    4 __pfx_show_stat
       2: 0000000000000020  2126 FUNC    LOCAL  DEFAULT    4 show_stat
       5: 0000000000000000     0 SECTION LOCAL  DEFAULT    4 .text.show_stat

$ objdump -d -j .text.show_stat --start-address=0x0 --stop-address=0x24 klp-tmp/diff/vmlinux.o 

klp-tmp/diff/vmlinux.o:     file format elf64-x86-64


Disassembly of section .text.show_stat:

0000000000000000 <__pfx_show_stat>:
   0:   90                      nop
   1:   90                      nop
   2:   90                      nop
   3:   90                      nop
   4:   90                      nop
   5:   90                      nop
   6:   90                      nop
   7:   90                      nop
   8:   90                      nop
   9:   90                      nop
   a:   90                      nop
   b:   90                      nop
   c:   90                      nop
   d:   90                      nop
   e:   90                      nop
   f:   90                      nop
        ...

0000000000000020 <show_stat>:
  20:   f3 0f 1e fa             endbr64


LMK if you want me to update the patch in this set, or drop it here so
you can update in ("objtool/arm64: Port klp-build to arm64").

Thanks,

--
Joe


