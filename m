Return-Path: <live-patching+bounces-2046-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBZfMJxElmmYdAIAu9opvQ
	(envelope-from <live-patching+bounces-2046-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 00:00:44 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 250F515ABF9
	for <lists+live-patching@lfdr.de>; Thu, 19 Feb 2026 00:00:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1E8530053CC
	for <lists+live-patching@lfdr.de>; Wed, 18 Feb 2026 23:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5052E888C;
	Wed, 18 Feb 2026 23:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OIN4oQPo"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A212773E4
	for <live-patching@vger.kernel.org>; Wed, 18 Feb 2026 23:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771455642; cv=none; b=MBHSGVe+HcbGy5nrkEVDpb4ze1e5X04Qn+Fh4GwClhn32+SRY7CVhdAJ0y/cvKYuhEQJwfYwEBysEgcqJ/WwBB/m7UOdZfLxbRqQ/6WT0u+jTzO6Ge8SnQFUoI3IERIMYjAk+2npGATXhxKHbCDwcUkbu5eBXk6XelGW/iiZCok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771455642; c=relaxed/simple;
	bh=SxGo6UdnphjjQeViKpegIs8L7Drae2gWpQWUNYbC8kw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GkmQEDPFMK5Bym/8vw9HBvuhZ+WvGa9lx88cMOqFN/4NSL80vg0qbUEpmuAXp2jG8gbqUeUou5+/oK21k4qj3MlWCiil/vQuyufYvHU2BQ7kPaNPG+NrPQb9ZHjjZ9siscjilTHhTeOFaeUm76zwepef9Qhbt5jSK7rXElQ2g3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OIN4oQPo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771455639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QP0l+D5nytpf3JtYLuWhZA2GAqgCk4RQjtJQOe1MPdc=;
	b=OIN4oQPoIo0dI7IknCj6w8rrGk5kUZYtC3htH5oFPFBElNe7BA/fPr0EJhhHJz64oavpW8
	It/4YkaSDlSFJPeUNQgTUqR8sJ5lxZpjJESNN4zJE7TU6CR1DU9tbTXn2s3ObkslsBEKOV
	ISfbvBkBvTOoRHm79E1MVaWly7xUoI4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-zJdHadtrPieNR7F_OejIAQ-1; Wed,
 18 Feb 2026 18:00:35 -0500
X-MC-Unique: zJdHadtrPieNR7F_OejIAQ-1
X-Mimecast-MFC-AGG-ID: zJdHadtrPieNR7F_OejIAQ_1771455634
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B4EB1956052;
	Wed, 18 Feb 2026 23:00:34 +0000 (UTC)
Received: from redhat.com (unknown [10.22.80.197])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65C351800348;
	Wed, 18 Feb 2026 23:00:32 +0000 (UTC)
Date: Wed, 18 Feb 2026 18:00:29 -0500
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, pmladek@suse.com, kernel-team@meta.com
Subject: Re: [PATCH 0/8] objtool/klp: klp-build LTO support and tests
Message-ID: <aZZEjfxgLWTWODE7@redhat.com>
References: <20260212192201.3593879-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212192201.3593879-1-song@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-2046-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 250F515ABF9
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 11:21:53AM -0800, Song Liu wrote:
> Add support for LTO in klp-build toolchain. The key changes are to the
> symbol correlation logic.Basically, we want to:
> 
> 1. Match symbols with differerent .llvm.<hash> suffixes, e.g., foo.llvm.123
>    to foo.llvm.456.
> 2. Match local symbols with promoted global symbols, e.g., local foo
>    with global foo.llvm.123.
> 
> 1/8 and 2/8 are small cleanup/fix for existing code.
> 3/8 through 7/8 contains the core logic changes to correlate_symbols().
> 8/8 contains tests for klp-build toolchain.
> 
> Song Liu (8):
>   objtool/klp: Remove redundent strcmp in correlate_symbols
>   objtool/klp: Remove trailing '_' in demangle_name()
>   objtool/klp: Use sym->demangled_name for symbol_name hash
>   objtool/klp: Also demangle global objects
>   objtool/klp: Remove .llvm suffix in demangle_name()
>   objtool/klp: Match symbols based on demangled_name for global
>     variables
>   objtool/klp: Correlate locals to globals
>   livepatch: Add tests for klp-build toolchain
> 

Hi Song,

One of the tests that Josh had suggested running to validate "no
changes" and git apply --recount / recountdiff was to touch most of the
.c files in the tree like so:

  $ find . -type f -name '*.c' ! -path "./lib/*" -print0 | xargs -0 sed -i '1iasm("nop");'
  $ git checkout tools arch/x86/lib/inat.c arch/x86/lib/insn.c kernel/configs.c
  $ git diff > /tmp/oneline.patch

which results in "klp-build: no changes detected" using gcc, but with
this patchset+llvm thin-LTO results in a few c_start/c_stop/c_next
uncorrelated variables.

Here is a minimal version of a reproducer:

$ grep LTO .config
CONFIG_LTO=y
CONFIG_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
CONFIG_HAS_LTO_CLANG=y
# CONFIG_LTO_NONE is not set
# CONFIG_LTO_CLANG_FULL is not set
CONFIG_LTO_CLANG_THIN=y

$ cat ~/min.patch
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 6571d432cbe3..96c6c8bb7228 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -1,3 +1,4 @@
+asm("nop");
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/smp.h>
 #include <linux/timex.h>
diff --git a/crypto/proc.c b/crypto/proc.c
index 82f15b967e85..1474800162bf 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -1,3 +1,4 @@
+asm("nop");
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Scatterlist Cryptographic API.
diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
index b7cab1ad990d..066e625ae14e 100644
--- a/fs/proc/consoles.c
+++ b/fs/proc/consoles.c
@@ -1,3 +1,4 @@
+asm("nop");
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2010 Werner Fink, Jiri Slaby

$ LLVM=1 ./scripts/livepatch/klp-build -T ~/min.patch 
Validating patch(es)
Building original kernel
Copying original object files
Fixing patch(es)
Building patched kernel
Copying patched object files
Diffing objects
vmlinux.o: warning: objtool: correlate c_start.llvm.15251198824366928061 (origial) to c_start.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate c_stop.llvm.15251198824366928061 (origial) to c_stop.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate c_next.llvm.15251198824366928061 (origial) to c_next.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate show_cpuinfo.llvm.15251198824366928061 (origial) to show_cpuinfo.llvm.10047843810948474008 (patched)
vmlinux.o: warning: objtool: correlate .str.llvm.1768504738091882651 (origial) to .str.llvm.7814622528726587167 (patched)
vmlinux.o: warning: objtool: correlate crypto_seq_ops.llvm.1768504738091882651 (origial) to crypto_seq_ops.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate c_start.llvm.1768504738091882651 (origial) to c_start.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate c_stop.llvm.1768504738091882651 (origial) to c_stop.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate c_next.llvm.1768504738091882651 (origial) to c_next.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate c_show.llvm.1768504738091882651 (origial) to c_show.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.15251198824366928061 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.15251198824366928061 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.15251198824366928061 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_show_cpuinfo.llvm.15251198824366928061 (origial) to __pfx_show_cpuinfo.llvm.10047843810948474008 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_start.llvm.1768504738091882651 (origial) to __pfx_c_start.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_stop.llvm.1768504738091882651 (origial) to __pfx_c_stop.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_next.llvm.1768504738091882651 (origial) to __pfx_c_next.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: correlate __pfx_c_show.llvm.1768504738091882651 (origial) to __pfx_c_show.llvm.14107081093236395767 (patched)
vmlinux.o: warning: objtool: no correlation: c_start.llvm.1768504738091882651
vmlinux.o: warning: objtool: no correlation: c_stop.llvm.1768504738091882651
vmlinux.o: warning: objtool: no correlation: c_next.llvm.1768504738091882651
vmlinux.o: new function: c_start.llvm.10047843810948474008
vmlinux.o: new function: c_stop.llvm.10047843810948474008
vmlinux.o: new function: c_next.llvm.10047843810948474008
vmlinux.o: changed function: c_start.llvm.14107081093236395767
vmlinux.o: changed function: c_stop.llvm.14107081093236395767
vmlinux.o: changed function: c_next.llvm.14107081093236395767
Building patch module: livepatch-min.ko
SUCCESS

And since we're here, it looks like there's a type:
s/origial/original/g.

--
Joe


