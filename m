Return-Path: <live-patching+bounces-625-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D874A96FCF4
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 23:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DD87B24BE9
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 21:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81F8C1D79A3;
	Fri,  6 Sep 2024 21:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XhE9ZY5h"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4F5158A36
	for <live-patching@vger.kernel.org>; Fri,  6 Sep 2024 21:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725656526; cv=none; b=qZ5ivL5XTm9PAT3PG11m7n0Z+s4adwQjNBFWM/mu5zIpRRVqgZPb9mIhW42tXSnxYjow69TVas6Lpi/JETeNKdMSxniK+BgdsjFKIdT8tXdrNFXJjrFd/ISOxORKaRA0eNVOm/WSVlfPgI5YhVFWzZagyZeiLAKwxGWKKWCScAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725656526; c=relaxed/simple;
	bh=1PvbEcEkAycxEh+oFXQ+UkKWnaHOLZeIUL7vy6IJyTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jMqBmj9qExfvHrAq3dHTTF4N/QyrLlhcpthfZKSG4owEgGU+PfwYqASZwNe9Tk/F3M30dri/2Sj1cwX2FUtxkyfp0vFEAhBvh/rwsPvA4oWnyxuzmqMBOticrreygxINteHL3ukxxM0KSOH4X+MmyB042YmWem4dzPBtb+UjsO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XhE9ZY5h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725656523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Slsc/q4gmklmRH5a0YDj3ElXcBDJLSNXpvyO6xBWXgY=;
	b=XhE9ZY5hhqpkUaLVY7RCfa690Wjo/x/qivLyFYFcsO85eVE1N3C1nBKBAZMU4Fnx5CRcmG
	2jQQEQd6oy6Z+odFSgTfBb/VwLUjlNgS3rLVP1Pks7yE0bI623tXar3dp6S/Xx8vayziyK
	79yiix0Xk8XpGOwFHMC/0K78v4BkRjM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-458-soR5ubLEOuiW-V7rOuoAbg-1; Fri,
 06 Sep 2024 17:01:58 -0400
X-MC-Unique: soR5ubLEOuiW-V7rOuoAbg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 684CC194510E;
	Fri,  6 Sep 2024 21:01:56 +0000 (UTC)
Received: from redhat.com (unknown [10.22.32.23])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF75D1956048;
	Fri,  6 Sep 2024 21:01:53 +0000 (UTC)
Date: Fri, 6 Sep 2024 17:01:51 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <Ztttv0Eo/FHyxo78@redhat.com>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZtsJ9qIPcADVce2i@redhat.com>
 <20240906170008.fc7h3vqdpwnkok3b@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906170008.fc7h3vqdpwnkok3b@treble>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Sep 06, 2024 at 10:00:08AM -0700, Josh Poimboeuf wrote:
> On Fri, Sep 06, 2024 at 09:56:06AM -0400, Joe Lawrence wrote:
> > In the case of klp-diff.c, adding #include <string.h> will provide the
> > memmem prototype.  For both files, I needed to #define _GNU_SOURCE for
> > that prototype though.
> > 
> > For the other complaint, I just set struct instruction *dest_insn = NULL
> > at the top of the for loop, but perhaps the code could be refactored to
> > clarify the situation to the compiler if you prefer not to do that.
> 
> Thanks!  I'll get these fixed up.
> 

Also, with the workarounds mentioned above, the two you sent to Song,
and the same .config I attached in the first email, I get the following
error when trying to build the canonical /proc/cmdline example:

  $ cat cmdline-string.patch 
  diff --git a/fs/proc/cmdline.c b/fs/proc/cmdline.c
  index a6f76121955f..2bcaf9ec6f78 100644
  --- a/fs/proc/cmdline.c
  +++ b/fs/proc/cmdline.c
  @@ -7,8 +7,7 @@
   
   static int cmdline_proc_show(struct seq_file *m, void *v)
   {
  -       seq_puts(m, saved_command_line);
  -       seq_putc(m, '\n');
  +       seq_printf(m, "%s kpatch=1", saved_command_line);
          return 0;
   }


  $ ./scripts/livepatch/klp-build ./cmdline-string.patch 2>&1 | tee build2.out
  - klp-build: building original kernel
  vmlinux.o: warning: objtool: init_espfix_bsp+0xab: unreachable instruction
  vmlinux.o: warning: objtool: init_espfix_ap+0x50: unreachable instruction
  vmlinux.o: warning: objtool: syscall_init+0xca: unreachable instruction
  vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
  vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
  vmlinux.o: warning: objtool: tc_wrapper_init+0x16: unreachable instruction
  vmlinux.o: warning: objtool: pvh_start_xen+0x50: relocation to !ENDBR: pvh_start_xen+0x57
  - klp-build: building patched kernel
  vmlinux.o: warning: objtool: init_espfix_bsp+0xab: unreachable instruction
  vmlinux.o: warning: objtool: init_espfix_ap+0x50: unreachable instruction
  vmlinux.o: warning: objtool: syscall_init+0xca: unreachable instruction
  vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
  vmlinux.o: warning: objtool: sync_core_before_usermode+0xf: unreachable instruction
  vmlinux.o: warning: objtool: tc_wrapper_init+0x16: unreachable instruction
  vmlinux.o: warning: objtool: pvh_start_xen+0x50: relocation to !ENDBR: pvh_start_xen+0x57
  - klp-build: diffing objects
  kvm.o: added: __UNIQUE_ID_nop_644
  kvm.o: added: __UNIQUE_ID_nop_645
  kvm.o: added: __UNIQUE_ID_nop_646
  kvm.o: added: __UNIQUE_ID_nop_647
  kvm.o: added: __UNIQUE_ID_nop_648
  kvm.o: added: __UNIQUE_ID_nop_649
  kvm.o: added: __UNIQUE_ID_nop_650
  kvm.o: added: __UNIQUE_ID_nop_651
  kvm.o: added: __UNIQUE_ID_nop_652
  vmlinux.o: changed: cmdline_proc_show
  - klp-build: building patch module
  make[2]: /bin/sh: Argument list too long
  make[2]: *** [scripts/Makefile.build:253: /home/jolawren/src/linux/klp-tmp/out/livepatch.mod] Error 127
  make[1]: *** [/home/jolawren/src/linux/Makefile:1943: /home/jolawren/src/linux/klp-tmp/out] Error 2
  make: *** [Makefile:240: __sub-make] Error 2
  klp-build: error: module build failed

I'm guessing that this happens because of the huge dependency line in
klp-tmp/out/Kbuild for livepatch-y, it includes over 2000 object files
(that I'm pretty sure didn't change :)

I can set this up on a live machine next week if you want to investigate
further.

--
Joe


