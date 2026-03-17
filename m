Return-Path: <live-patching+bounces-2218-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCDZBkqjuWlILgIAu9opvQ
	(envelope-from <live-patching+bounces-2218-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:54:02 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A53032B13E8
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:54:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E9E7E30478A0
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 18:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8066D3F660D;
	Tue, 17 Mar 2026 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FC+l/gja"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A183F7A86;
	Tue, 17 Mar 2026 18:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773773636; cv=none; b=ll9SQ6xQGjx7U4jqo9BgL+gao7tqPvT2fZpySzRiYxeYJOFe1jbR1K9gW29EtBGtw1GxtHRCgfY7W0+S2U8SP3gU/T6coSIomB2pI+FIcsv2v8Z3Y7aoF3LTGMowgDIw+/yPwZUw8VA+3XZ4ZqD3YotPXguvsPD2VyoEKsu2Ohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773773636; c=relaxed/simple;
	bh=jNR9DAFkcObKj+OM+bo14Lk9Gz1PHKQn1T7rQ6OiOJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhGJCpOW46eZJistApQ3gl+x5C63seFSd7afLHyY7gtmu6JFfMGc5v3rmEGTBKDIvMbbY/+/vbrzmvAXctUybQ5GbcHI0p0YDu5Mmf8O0WDKD84A40bEyD5ZlcYcWXZSRcWKujbCTTbr/BpFVaAdnTZdQjzE3I/oGDw2B5Sp27g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FC+l/gja; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C21C4CEF7;
	Tue, 17 Mar 2026 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773773636;
	bh=jNR9DAFkcObKj+OM+bo14Lk9Gz1PHKQn1T7rQ6OiOJc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FC+l/gjaFn+93bJCK46Y0q/6rRibEoUlvSL/UMR5T8Za/4IK41Xxik+6YKre8abFp
	 QSFj7mMRmp2LB1bWOm1sH/rPoyCmvrWcdvoZaAXqFncS7J4rP6ZHNm7baCh3NoQvx4
	 8uiGd2cBdgQPYmMubqHBTwuTf24frFIo62fbcH+TwZ4y0slrp3HWFt0zHLtzw36VwS
	 wYjPKzo7yQJoY4YVnAoYzWwPYFeKOluURi/Ayjk7uMTn34k16x2wJSDTJFfcbvrghC
	 NJ5YWupohRWV4a2m9tLy3RuLhY9hG1yoMXhYg0CE+7NDC+wLa9i/WLd/SoVh/FRiqb
	 +z8y3PcMNlUTA==
Date: Tue, 17 Mar 2026 11:53:52 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 14/14] klp-build: Support cross-compilation
Message-ID: <74fwwcyggggcnh7pj2i7nhglhagltkqeth4ykhtqs4izx4dtig@lzyai66d2vn6>
References: <cover.1772681234.git.jpoimboe@kernel.org>
 <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
 <CAPhsuW6Cyw_z+9sWt5G1XOp94z8BbwNmsoVE9=iM8WQfkuNDBA@mail.gmail.com>
 <xzezfjfb5uttvmg2divzk3toym3qqvkh5c4w2enamsrku342m3@bogfmdj65wql>
 <e2yxamlxwif5kxur7thr4x7yp7ppbde6awzm6vomdfkg6auxeq@aaahh3aclf2e>
 <CAPhsuW6SsDTDCJ8-w9OP3FeS2d0Rj6jgP7gYbzD3pZhAmK5nAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6SsDTDCJ8-w9OP3FeS2d0Rj6jgP7gYbzD3pZhAmK5nAg@mail.gmail.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2218-lists,live-patching=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A53032B13E8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 17, 2026 at 11:21:43AM -0700, Song Liu wrote:
> On Tue, Mar 17, 2026 at 10:52 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> [...]
> > >
> > > Yeah, I think that would be a good idea.  Will do that for v2.
> >
> > So, in general ARCH is complicated.  For example:
> >
> >  - ARCH=arm64 would never match "uname -m" (aarch64)
> >  - ARCH=i386 would use the same gcc binary (no cross-compiler needed)
> >  - I'm sure there are many other edge cases...
> 
> Agreed. I haven't worked with i386 for a long time, but I did notice
> the arm64 vs. aarch64 difference.
> 
> > Instead of a manual error, it may be simpler to just let the build fail
> > naturally if the user doesn't set the right ARCH.
> >
> > Though, I think the check can be improved slightly, as ARCH is a
> > reasonably good indicator that cross-compiling is happening.  So I can
> > at least add an ARCH check at the beginning like so?
> >
> > cross_compile_init() {
> >         if [[ ! -v ARCH ]]; then
> >                 OBJCOPY=objcopy
> >                 return 0
> >         fi
> >
> >         if [[ -v LLVM ]]; then
> >                 OBJCOPY=llvm-objcopy
> >         else
> >                 OBJCOPY="${CROSS_COMPILE:-}objcopy"
> >         fi
> > }
> 
> Do we need ARCH when CROSS_COMPILE is set? I was
> under the impression that CROSS_COMPILE doesn't require
> ARCH.

If CROSS_COMPILE is used without ARCH, it will just try to use the host
arch.  I'm not sure if that's considered cross-compiling?   I suppose it
should use the CROSS_COMPILE version of objcopy in that case?  Though in
practice it probably doesn't matter.

I guess the original version of the function is probably fine and we
don't need to complicate matters.

-- 
Josh

