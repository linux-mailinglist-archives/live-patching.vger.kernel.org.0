Return-Path: <live-patching+bounces-2508-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +F7YICUy62lfJwAAu9opvQ
	(envelope-from <live-patching+bounces-2508-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:04:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BF81745BD79
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 11:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5C7F5301DAFC
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 09:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D061C34B19A;
	Fri, 24 Apr 2026 09:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8syiyWp"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671AE31B80D
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 09:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777021349; cv=none; b=ivE66rMwMXXAYeULFjSgmJSnKrNlSXSCaY8KQ+eBzx4Z7dncZ7sWv8UKtnjZ8WPbKOQHTBl88lBlK8f2K+7hUBzVncvqfzQcTE0U1NLmHwkgHA/SP4sdylNs45fdv8AZR5Yw69rrwkaKgKuBZQAeEh0mEV05wwEir9XSJpEs/bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777021349; c=relaxed/simple;
	bh=Kr8868m6WphNKuwQf11ud6IEmjG3qyhbdx3HYbpfH2c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GJEImaRO1i2weyXwRudyIp6X7QzWhALURKLu9wa8pxzVuBlAWxJ43ynopTNcpZaHAxGZWzs/+aOflqmlls1lgvkVOj/AvHnpG8FeCd+esemCzJXDxdoqzmZSDYv7aJxN3lPpj3FTwT4Pjg0iyuthqBohiNf5kyNxmWvgQh6GSOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8syiyWp; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d7213b6ebso4989831f8f.3
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 02:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777021347; x=1777626147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9t+NkK05MW8q4GR8hH9BZxdUoTVDsdPAfVptfnaSn9w=;
        b=D8syiyWpQvLkIM+LanzXxnCX2rhdmgjHiwiPzKIv5VcI05sUwZ/cQacfvRLYue/DjS
         oq5Iv14E7rWy/AtQJaMI3bH3e805dmkcZkV4Mmjp/D86JSuZU7MAlqncMFsooD8+ecPF
         zTkCCAWsyAvtMxBfNX/oHErhQqxw6zLyD56DN8Z9294bT7695Wo8rd6kdphTmQymixlk
         Zy4crghc550J8a7sEjGZJLtHYusrkDHeEYPytj0Zvnuf3MFcqt/Rwmk8NvYxEkvOi+8N
         qNQmTdsVIlONpMHotNxILou5+nv/0+g/EyGXT6jYeez8+srVksfKQTUwdUfYoYANYJgg
         PAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777021347; x=1777626147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9t+NkK05MW8q4GR8hH9BZxdUoTVDsdPAfVptfnaSn9w=;
        b=kRiK/24uSjcFZJJE6VPdYAwHGo0vUfsO4QrY357fvrW75X6jOnIfr9csRVe1SGb9w9
         5dgMpaDMtng5C5lms5khs6SBAy4GtTOagop/c7oL8jhv9wIs9XXudlTR9FfxKgafGC5D
         Wzf9MVdoojp/QMKlddYtovwMZcKaPnp6fePGr7UblPCEoIqyN/BpVY+AXOWXYUc4394O
         LiFHPPChomzHStbKI78GYcv3QoRtbWSLxRGKefS7BXA4JU67kTuBC+oMttEB6kgVLuV2
         Fk2jiPEkvRthZjMRxePa5XCUMGWUOCzKc+wFS0DCj4HyGm1DSlheAxRC+Df7KIaLYNaN
         2Bbw==
X-Forwarded-Encrypted: i=1; AFNElJ92xRxldzMrVBgHqPRFwF6yi1fG409W7F9YhP77RJX/99Fx1sHePC8FNUtmPNxQUlcqoOx1W7WdtetqhJqp@vger.kernel.org
X-Gm-Message-State: AOJu0YxmR3LsCL0lUIuYh6dqt46wH567/PRocwGD2C2/2ZG/DvhBR5em
	tU+VJYkG4x73ky9rfFkYkEPV9dDRocYIoQrbmkAQlQTX6vNuxPbNPOC9
X-Gm-Gg: AeBDietfROKGxphd5A1QUqJTwk445WhW9CwM/v6np6Q49sG0kwqR5yZqd9kyiyf5A7E
	DhyIN0THdN70cxIi4CfX3Tatwc+Spq8L9tUJfnbs5vC1xyKGM5Dc7RQ+XL5zXvdMbnCGsXqgA3r
	TJ6J/JxmG95/MAVon2BsMkigcCNWaEU6xW3evw0aZ9/014dykPKOHknDE8nvFTwQqVjnSZEn0Qs
	yyDRi0M13nLVIs++xcFnZk/K6/cUVi0jLof3Wn+sv+Rc5et4wd6PxLcwGr2fp5hGgevEqtYRPBp
	szc8tqOZlWHt/tPrOs61ZgoD+gn5baDt988WHq3GC7BQ/nV6g93jtMqfNVBW9kGivwbKt6sapUM
	xf4MtqvhAlpYo+Gq3BlhZlvNHGsSQarhBsIk0F1QoBBFawDWDofZJGFQKRbBQYzVyRnFc3d2NBj
	IATpFmP0dMwxQZ9eRC27L0AjRHU9weAm8Arc4lKVCZ5RSksqCmaZcyoP70Tl1e0zwyXxqPExqSl
	VM=
X-Received: by 2002:a5d:5d83:0:b0:441:1e41:19f with SMTP id ffacd0b85a97d-4411e41035bmr23325759f8f.24.1777021346538;
        Fri, 24 Apr 2026 02:02:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb135asm63482119f8f.6.2026.04.24.02.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 02:02:26 -0700 (PDT)
Date: Fri, 24 Apr 2026 10:02:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, Joe Lawrence
 <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, Miroslav Benes
 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH 45/48] x86/Kconfig: Enable CONFIG_PREFIX_SYMBOLS for
 FineIBT
Message-ID: <20260424100224.69723776@pumpkin>
In-Reply-To: <20260423162902.GC641209@noisy.programming.kicks-ass.net>
References: <cover.1776916871.git.jpoimboe@kernel.org>
	<70107aab81b01f8a2360f052ff550a9e97c30f79.1776916871.git.jpoimboe@kernel.org>
	<20260423084758.GY3126523@noisy.programming.kicks-ass.net>
	<n6xqf563o4moyl3sqp37ymakjhyvbxfinghi5k5lygeocak6ns@ugrn3b7csjot>
	<20260423151925.GG1064669@noisy.programming.kicks-ass.net>
	<gpq7mfal5gydlrqsm5mza5hzx5aa2rq7yk6olozlzotdnl7e24@ljzzzwwsputr>
	<20260423162902.GC641209@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BF81745BD79
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2508-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:email]

On Thu, 23 Apr 2026 18:29:02 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Apr 23, 2026 at 09:23:12AM -0700, Josh Poimboeuf wrote:
> 
> > > > Sorry, how do you get 64 here?  
> > > 
> > > DEBUG_FORCE_FUNCTION_ALIGNMENT_64B=y  
> > 
> > Ok, so in that case it would be 5-byte cfi symbol and 59-byte NOP gap.
> > Or a 64-byte pfx for the !CFI case.  
> 
> Just so.
> 

Isn't there also an average of 32 NOP bytes to align the 'gap' on a 64
byte boundary?
Has anyone looked at changing clang to take a parameter for the size
of the gap?
That would significantly reduce the overhead for small functions.

	David

