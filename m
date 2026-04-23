Return-Path: <live-patching+bounces-2496-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOkYC+xo6mkHzAIAu9opvQ
	(envelope-from <live-patching+bounces-2496-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 20:46:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD57456300
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 20:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 591253002338
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 18:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21D793A7831;
	Thu, 23 Apr 2026 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tj3nHrMx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F0B37E2EA
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 18:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776969960; cv=none; b=kVlnMG5UTWsb9J8pGU4YMmFBlcmUzB7sOwZgQ2NYFO8bEH4uMDcT2VgJ5X4bu1BIIZ7OZeSMzNd1/1roL1rdT2KedHhE0jHit7llLmlXzTA2pN4BRbhluIJkQAHppMASPiEU3O6hDejtUtLDag7sR5/jAktX00KITFUck035pS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776969960; c=relaxed/simple;
	bh=m/ZpdNn5Mf6L4nMna3Ul4Dg+9NODevcLdQNyrE7p4mY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q+XnV+1/f9yGJOt7uoyfR1G3RFIqFd/l9YdqlAHJM30tKa/QVMKUaiMygwFljxA8XU7HS1xaWZ94G3crEicGUfd+gNmfcE80/SEX5B4J+ow7nBiJ3ANT5sW9lO6oxjDganMeIrJtx6gIG8ON4gVpG65MM6on3G+eTfNl3VFaJKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tj3nHrMx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BFEC2BCC6
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 18:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776969959;
	bh=m/ZpdNn5Mf6L4nMna3Ul4Dg+9NODevcLdQNyrE7p4mY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Tj3nHrMx8VoSPTRGLno7OH3+RXxjVWgNmLePCBkMOMDYRPKT2sGfvx0xgbXDehEiv
	 XeSmJxWIXf2is8cdj+60eoFCIZ961/9vtbQyqL+fAkGUQrQ+osFD+xHyRCZyhDMdZn
	 x3hLoj+xb372Ms9QwiSRW/cvu8j01RIUNgfaDfQm34g+Qru3dQjkken97Bee/xeeMZ
	 oneed0i0NyvuZKbqJ8i9vCbUjfUdfgenX4HKi8s32d0G9kVPdJIhXBeM1mIakHbL+G
	 +Q7BQMcnxntvIXFkqYvjdf9sBJ67vj4rA7V77ouNU2u6fbWYwSIVMSPwA2b58V69Eo
	 HiatxrwhDuDXg==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8a3342d301aso68916046d6.2
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 11:45:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/qwkVDbIe/bK8VXcYGy0+B1UY+MkIw86ctmDDNoCY2J6dkrMoXYOLj7Jc70sDh2gjRAwbUONR+nFZNiX2B@vger.kernel.org
X-Gm-Message-State: AOJu0YypFp+L0Xu/H1ILppABX/ZLPM4+pxHfA+e80e72zp3CwBoTsFN0
	kbazyUTLBOI/DK1fjwl7qUuMBTQBTicAKbo/OJ/cSiecnOw37a3HOEy/S5s3Gf0Rq4XOlQHwLaF
	fLXnGqhLAgNoGZRByw/dEcp7EM0UdXsE=
X-Received: by 2002:a05:6214:588e:b0:8ac:a48a:a586 with SMTP id
 6a1803df08f44-8b02803f167mr442250116d6.14.1776969958799; Thu, 23 Apr 2026
 11:45:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <f2a97da92796708f77c6fb3e07816f84874b79a4.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <f2a97da92796708f77c6fb3e07816f84874b79a4.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Apr 2026 11:45:47 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4-HXpoQmsYXE5LOEe1PAxC7dwn3Pm=Kfq0wfRuO5Cd-A@mail.gmail.com>
X-Gm-Features: AQROBzA3Zh-kztFUwHu0ZiVZha48W2vCY2hYYi-VHXJthxJfxOnIRv7Ta9hhfd0
Message-ID: <CAPhsuW4-HXpoQmsYXE5LOEe1PAxC7dwn3Pm=Kfq0wfRuO5Cd-A@mail.gmail.com>
Subject: Re: [PATCH 01/48] objtool/klp: Fix is_uncorrelated_static_local() for Clang
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2496-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3DD57456300
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> From: Joe Lawrence <joe.lawrence@redhat.com>
>
> For naming function-local static locals, GCC uses <var>.<id>, e.g.
> __already_done.15, while Clang uses <func>.<var> with optional .<id>,
> e.g. create_worker.__already_done.111
>
> The existing is_uncorrelated_static_local() check only matches the GCC
> convention where the variable name is a prefix.  Handle both cases by
> checking for a prefix match (GCC) and by checking after the first dot
> separator (Clang).
>
> Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diff=
ing object files")
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

