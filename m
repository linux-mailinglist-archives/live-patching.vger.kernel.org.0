Return-Path: <live-patching+bounces-2242-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UG0xFhEtvWmI7QIAu9opvQ
	(envelope-from <live-patching+bounces-2242-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 12:18:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF582D96A7
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 12:18:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 533F6300E48F
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 11:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48FBD3A5446;
	Fri, 20 Mar 2026 11:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kgRuvsT9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JacdX4NA";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="kgRuvsT9";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="JacdX4NA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A4A3A4523
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 11:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005516; cv=none; b=fOD/0SCygDQTrxk4prSgKMJ10iIR4nG+nvF3JrcLkLKOUAr/p2AnuWXRaG8vW5ZrG0p6H8XYr8AOB37IEflTWlJMoJeThmBjmVTFxsmRGb0H+lt3z5gg4nlur0qNcWKHb3ukJUu/Wse58Ya/wSm+LGDP8ygzcBwt4LaaOCP8DMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005516; c=relaxed/simple;
	bh=gwdkwNw1aCvfhHjq2xoOr/jQl/jvktxMB15tf+L9W7c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=KPjbDm+NY0t19/NyTeOH/US54veVlFF6ThLvGTLUI6Pz9sq335pxiBJmTyULxqPp7Fd7ThOycEPJLwDE1OmLFduwgJ7aoje9myinG7H3qpbKqg0d64SGzPay5v0wbSB0k9OBi6rtW7lb/UGqJuUkzUcqPwdvsgWzPhiOLXWuzY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kgRuvsT9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JacdX4NA; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=kgRuvsT9; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=JacdX4NA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from pobox.suse.cz (unknown [10.128.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4F4684D257;
	Fri, 20 Mar 2026 11:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774005513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEKzWlRteGURu5UFh1+Dmq/KxX/rb8EkALXBIWobc1Y=;
	b=kgRuvsT9YXCHTi1Wsrn+gTu69NEMWsgwpWzK/JDK86hy9BVrbpHIx/dy6oQa0aYwQo7nAv
	KfDLLVLYuVLgYtA71VvmMQKMddVBr7z2aDek93OPif4hl8ehJB+7HUV0cKE6bw1ZEV0768
	e/XC4QcQqcTg9+2FwOBTJmalhc0Ko5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774005513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEKzWlRteGURu5UFh1+Dmq/KxX/rb8EkALXBIWobc1Y=;
	b=JacdX4NAREjXR/xmQZOlii4IFZ6lmo17g6a6b5GYzCJGCWEY7j1h6cyBM8iE3aklo70PUZ
	o3g+C8AxRcBWmEBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774005513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEKzWlRteGURu5UFh1+Dmq/KxX/rb8EkALXBIWobc1Y=;
	b=kgRuvsT9YXCHTi1Wsrn+gTu69NEMWsgwpWzK/JDK86hy9BVrbpHIx/dy6oQa0aYwQo7nAv
	KfDLLVLYuVLgYtA71VvmMQKMddVBr7z2aDek93OPif4hl8ehJB+7HUV0cKE6bw1ZEV0768
	e/XC4QcQqcTg9+2FwOBTJmalhc0Ko5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774005513;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEKzWlRteGURu5UFh1+Dmq/KxX/rb8EkALXBIWobc1Y=;
	b=JacdX4NAREjXR/xmQZOlii4IFZ6lmo17g6a6b5GYzCJGCWEY7j1h6cyBM8iE3aklo70PUZ
	o3g+C8AxRcBWmEBQ==
Date: Fri, 20 Mar 2026 12:18:33 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
    Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>, 
    Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] selftests: livepatch: test-kprobe: Replace true/false
 mod param by 1/0
In-Reply-To: <a57eb2eb73eb8bd817196b8505ab59d5c3bc187b.camel@suse.com>
Message-ID: <alpine.LSU.2.21.2603201213400.12616@pobox.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>  <20260313-lp-tests-old-fixes-v1-2-71ac6dfb3253@suse.com>  <alpine.LSU.2.21.2603191401380.22987@pobox.suse.cz> <a57eb2eb73eb8bd817196b8505ab59d5c3bc187b.camel@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2242-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[suse.cz];
	DKIM_TRACE(0.00)[suse.cz:+];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mbenes@suse.cz,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,pobox.suse.cz:mid]
X-Rspamd-Queue-Id: 5AF582D96A7
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, 19 Mar 2026, Marcos Paulo de Souza wrote:

> On Thu, 2026-03-19 at 14:03 +0100, Miroslav Benes wrote:
> > A nit but I think that "test-kprobe: " is unnecessary noise in the
> > subject 
> > and can be dropped. It applies to all patches in the series.
> 
> Ok, I'll drop it in the v2.
> 
> > 
> > On Fri, 13 Mar 2026, Marcos Paulo de Souza wrote:
> > 
> > > Older kernels don't support true/false for boolean module
> > > parameters
> > > because they lack commit 0d6ea3ac94ca
> > > ("lib/kstrtox.c: add "false"/"true" support to kstrtobool()").
> > > Replace
> > > true/false by 1/0 so the test module can be loaded on older
> > > kernels.
> > > 
> > > No functional changes.
> > 
> > We also define a bool module parameter in 
> > test_modules/test_klp_callbacks_busy.c. Does it have a similar
> > problem?
> 
> No, because n/N was accepted as false already on 4.12 (SLE12-SP5). I'm
> not sure about older versions tough.

strtobool() (predecessor of kstrtobool()) has it from the beginning and 
that is ~2010 which predates the kernel live patching itself so I think we 
are good.

Miroslav

