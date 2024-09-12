Return-Path: <live-patching+bounces-651-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 246A8976B02
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 15:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD3CA2818BB
	for <lists+live-patching@lfdr.de>; Thu, 12 Sep 2024 13:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91B771A76DD;
	Thu, 12 Sep 2024 13:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aBvmGCmn"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC651A3020
	for <live-patching@vger.kernel.org>; Thu, 12 Sep 2024 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726148659; cv=none; b=AJrnAb7QcC1iCnA+D2VGNMYZh5jVH9MqObt/Hv1iPbiXZcKbNN+ubPz9n+77AqaMdZkeK375OIl/tbwyxYCr3+MU7FR4HE2Dfh5MxnWNHNLdzsY3Zu7aqOx7LA9G6jocz8rsCeYi3HSVi+vebGPMoOIw4yH+vTHfMhu1d4bwEM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726148659; c=relaxed/simple;
	bh=6QLGfjqph9dCdgfpbGIDUHpt/wnZt4RxogTgn+JRE4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AtVunJm5sPfTKTGaZerA0AWxqHDk5xHTPTj5b2gq/oglyf3dpgLgyc7nK/Afry5VeZzDwgXZoV2DRiJOFmLdLPLYLmVQ0WE/Yx0GJ/67cPTLqPA4VzNkp21uzMYHj4DB6TUKq8MX+k1zMMv/4PiFRBdKCezjASVSOyEb2IH6Bt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aBvmGCmn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726148657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xLEeXW3zplWiS6wK6khRG9CmZ0AgbbGOrPcRRbNfBu8=;
	b=aBvmGCmn7un+bwlPRsrv8ahYiJ1L6NcFBwQ3mhisX03YGM6urIuynVjHHrOoW7nRcmlrIc
	1Q6XfSIvDATK2SvgYBYVl1pH7wvf4VG2kOhUhoN4z1m7TxHcwEmZUGWVn2s7nV71PFeBJ1
	Cm7QL8ynVmuBp3tW3U4TDaGN0htlIyI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-548-TQwyIp4KOIejDGQVlrfrKg-1; Thu,
 12 Sep 2024 09:44:11 -0400
X-MC-Unique: TQwyIp4KOIejDGQVlrfrKg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 695C2193E8F1;
	Thu, 12 Sep 2024 13:44:09 +0000 (UTC)
Received: from redhat.com (unknown [10.22.8.105])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB49C1956086;
	Thu, 12 Sep 2024 13:44:06 +0000 (UTC)
Date: Thu, 12 Sep 2024 09:44:04 -0400
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
Message-ID: <ZuLwJIgt4nsQKvqZ@redhat.com>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <20240911073942.fem2kekg3f23hzf2@treble>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240911073942.fem2kekg3f23hzf2@treble>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Wed, Sep 11, 2024 at 12:39:42AM -0700, Josh Poimboeuf wrote:
> On Mon, Sep 02, 2024 at 08:59:43PM -0700, Josh Poimboeuf wrote:
> > Hi,
> > 
> > Here's a new way to build livepatch modules called klp-build.
> > 
> > I started working on it when I realized that objtool already does 99% of
> > the work needed for detecting function changes.
> > 
> > This is similar in concept to kpatch-build, but the implementation is
> > much cleaner.
> > 
> > Personally I still have reservations about the "source-based" approach
> > (klp-convert and friends), including the fragility and performance
> > concerns of -flive-patching.  I would submit that klp-build might be
> > considered the "official" way to make livepatch modules.
> > 
> > Please try it out and let me know what you think.  Based on v6.10.
> > 
> > Also avaiable at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-rfc
> 
> Here's an updated branch with a bunch of fixes.  It's still incompatible
> with BTF at the moment, otherwise it should (hopefully) fix the rest of
> the issues reported so far.
> 
> While the known bugs are fixed, I haven't finished processing all the
> review comments yet.  Once that happens I'll post a proper v2.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build-v1.5

Hi Josh,

I've had much better results with v1.5, thanks for collecting up those
fixes in a branch.

One new thing to report: depending on the optimzation of
drivers/gpu/drm/vmwgfx/vmwgfx.o, objtool may throw a complaint about an
unexpected relocation symbol type:

  $ make -j$(nproc) drivers/gpu/drm/vmwgfx/vmwgfx.o
  drivers/gpu/drm/vmwgfx/vmwgfx.o: error: objtool [check.c:1048]: unexpected relocation symbol type in .rela.discard.func_stack_frame_non_standard: 0
  
I modified check.c to print the reloc->sym->name in this case and it
reports, "vmw_recv_msg".

If I recreate vmwgfx.o and dump the symbol table, I notice that this is
a NOTYPE symbol (probably because of vmw_recv_msg.constprop.0?)

  $ ld -m elf_x86_64 -z noexecstack   -r -o drivers/gpu/drm/vmwgfx/vmwgfx.o @drivers/gpu/drm/vmwgfx/vmwgfx.mod
  $ readelf --wide --symbols drivers/gpu/drm/vmwgfx/vmwgfx.o | grep -b -e 'vmw_recv_msg' -e 'vmw_send_msg'
  148334:  2198: 0000000000000010   183 FUNC    LOCAL  DEFAULT 1255 vmw_send_msg
  151116:  2234: 0000000000000010   409 FUNC    LOCAL  DEFAULT 1251 vmw_recv_msg.constprop.0
  180895:  2615: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT  UND vmw_recv_msg

I don't think the config matters (I used the centos-stream-10 config) as
long as the driver builds.  I only saw this with a rhel-9 gcc version
11.5.0 20240719 (Red Hat 11.5.0-2) and not fedora gcc version 12.3.1
20230508 (Red Hat 12.3.1-1), which kept vmw_recv_msg w/o constprop.

--
Joe


