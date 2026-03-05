Return-Path: <live-patching+bounces-2134-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCBPIncFqmliJgEAu9opvQ
	(envelope-from <live-patching+bounces-2134-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 23:36:39 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E5D82218F2E
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 23:36:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2DBED300BD96
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 22:35:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81E65350D46;
	Thu,  5 Mar 2026 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0C3kVz+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5B7330666
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772750144; cv=none; b=Wdo8fDJPVVs4I+vgqUv5SKLbBH8cQChg6dUcPe4PO4NOtBKkM9AZrXgy6K88j1jh9zZiLglol5IgttU6MznR/jdUeVWn1uyvBeM0x7H25kHUAvOZOu33vQB/vQnCY1FZ7mnXUVfc8aw3PBcMVd4QY0stYt6aeV4yNAvUeamb34M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772750144; c=relaxed/simple;
	bh=k9fgVDCS9Kf15aThWz8lC1qzlWNcBvRYl0C449CWlfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2mwpnznXEbCJJe8LF2agxFqmN+Js8QEAgYlth59F7CO+yHt6Ac03w+FXL6lSzljlw3D4jIY8rIh6V/PmxjK+1iLAQJPaOyECDmZdf3vbHOZ8mRfF95wHlXfYrNqDCE/fVmSbfSCuoPDy5xvWyti/ydSUIDUjp8s1A/2jNohZPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0C3kVz+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAF1C116C6;
	Thu,  5 Mar 2026 22:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772750144;
	bh=k9fgVDCS9Kf15aThWz8lC1qzlWNcBvRYl0C449CWlfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N0C3kVz+SX2Y2Ab2cEgvXS6Qh6DULTSHkk/tYNl063mwM0w5T0Jlv4sYwnGPj1O+q
	 qqOocR0AuLuv2h3YLX9jEwxZWvMVQPS+ElV1DqZ5xWB1EE+/txSUpWQTkpPbnNwlTc
	 BTWSu0mXXa006DsvJQ+YXd8DxOLm5IPKN/1ojlTXZ6L7fg3hsGQtXNzPVwF7ny94fT
	 OLTavKcWCNVCdqIY7mJaJrdCZrlcuzhIi7zzih4ifn1BKXTA7tovj/6zAcOD5Q2b0Z
	 mBufFy5mnbaWJuo0Cve4PhNVb8ntKKgKX093stk22SgbpoSBw8ej5waosTTWuKhcQs
	 Y9uyCNLEWjeNg==
Date: Thu, 5 Mar 2026 14:35:41 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when
 short-circuiting
Message-ID: <w6uwlcdd7eb247lj4r5khrliiymbpapshmaror3x3olfaamj6a@4ukxobzqj7fo>
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com>
 <aZSUfFUfpUYIbuiA@redhat.com>
 <zyxlceita2k3szzck5fwhhnpinh3twtzpr23xkdxdpj4opkgog@dnsvvttl4r3x>
 <aaZFUL_yCS3_wHnd@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aaZFUL_yCS3_wHnd@redhat.com>
X-Rspamd-Queue-Id: E5D82218F2E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2134-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 09:20:00PM -0500, Joe Lawrence wrote:
> I finally figured out why you couldn't reproduce, in my tests, I never
> built the original kernel, I jumped straight from a clean repo to
> starting up klp-build.  If I perform an initial make before running
> klp-build, then the sequence works as expected. 
> 
> - If skipping the initial vmlinux is an unsupported use-case, then we
>   can ignore and drop this patch,
> - or perhaps detect and warn/error out 
> - If this is something we need to support, then your suggested version
>   below didn't work out either...
> 
> The following change committed on top of v7.0-rc2:

Thanks, I was able to reproduce this and figure it out.  The problem is
that "make oldconfig" doesn't sync auto.conf, whereas a full make does.

So if you do "make kernelrelease" before the first build, it may be
wrong.

And apparently that's intentional:

  commit a29d4d8c5669a658b5a091b38205c13084967ce7
  Author: Masahiro Yamada <yamada.masahiro@socionext.com>
  Date:   Fri Jul 20 16:46:35 2018 +0900
  
      kbuild: do not update config for 'make kernelrelease'
      
      'make kernelrelease' depends on CONFIG_LOCALVERSION(_AUTO), but
      for the same reason as install targets, we do not want to update
      the configuration just for printing the kernelrelease string.
      
      This is likely to happen when you compiled the kernel with
      CROSS_COMPILE, but forget to pass it to 'make kernelrelease'.
      
      Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
  
  diff --git a/Makefile b/Makefile
  index 8ca9e0b114f1..060874d85e0d 100644
  --- a/Makefile
  +++ b/Makefile
  @@ -225,7 +225,8 @@ no-dot-config-targets := $(clean-targets) \
   			 cscope gtags TAGS tags help% %docs check% coccicheck \
   			 $(version_h) headers_% archheaders archscripts \
   			 kernelversion %src-pkg
  -no-sync-config-targets := $(no-dot-config-targets) install %install
  +no-sync-config-targets := $(no-dot-config-targets) install %install \
  +			   kernelrelease
   
   config-targets  := 0
   mixed-targets   := 0



So the fix is just to do "make syncconfig" before the "make
kernelrelease".  Let me write up a proper patch.

-- 
Josh

