Return-Path: <live-patching+bounces-2533-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +PWHEXnm62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2533-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:54:01 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id BC6FA463999
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4ACD9300C93C
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:53:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB893469E7;
	Fri, 24 Apr 2026 21:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctgWxEIa"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DE6336884
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067595; cv=none; b=YYmYLazde7atS7QeCI4oPg1Eg1CUMInQ+5Cc5fexJd1M9hYxWUfl6D5aMR53zaBhjf2y856ol05a8DgPpHzsD2lytVClFdiftwCSbH4juVoYXqHScZquugRHVNqwp259qeEOqraxr8bbnr88/iIseW8nx455yeEQOPvUb01L9VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067595; c=relaxed/simple;
	bh=zHLq9qhpOJmBDCl0kNoIwFpLE0RnRw4BnWgYqGthgYw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJT4+YZuS3HjcuDz+/EKsri4ul3ZCf60ZHczxTMEM8j+P8Tjo/dro3tKdgecoBVWaE55BqfY4yltKu2Z6Bw411wFVQAf0bxUTZfXy2n092pKX54yp8Ts0R+Qzayw0CLbBpGlXu/629Ftk2+tTPd0cWYoRR0jozfHdmh/Z/iOjQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctgWxEIa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3009FC4AF0B
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067595;
	bh=zHLq9qhpOJmBDCl0kNoIwFpLE0RnRw4BnWgYqGthgYw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ctgWxEIa3T294tEnWNSAVzgmzt4+5R32q7eSprA8sU+B0hfpMKihRU8qRiwlAC2tb
	 GpNGXE4BvstRgJROTgGjFpDuWsNW24BGnMQMim1NBbjhRK/pd1FaWqOp99xj2rIpxI
	 /ymZRFAh06aIrsmN03RwcK2j3YgGssq6R0OLXqq4ka9oNvTTY/Ze///GJ9atT/gb34
	 8N+GAVAXYOAwb7P/BP7b6vtTRsLK7UqcgOsBexz3aw+FsF2ZnHq6/nH3p3Pcjs4h/L
	 XbW1Ov61xwYsqKMbIAvihv+ZjTAM4eAdEP53l4r6gS1o81AcyWS9sgf9VgYQ23ubuG
	 7FwwZAFSt2c/A==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50e63771d91so67446831cf.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:53:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/3DTG5adwv0pDdFZkYUtRS6EnF0ymFtOWLIff58mMEIjwY0tmpZakJCF6OG3mcs5ngv5/MRQh6hqdVXxDQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6ELZmsQ1rjPy2kyEqavp2ZG0dYJ6xm2gg8sJDkahoP6XJm5gC
	mz0N00yCE6r9AY6Bn1C/7hs5uXpPXg2ZazbAia1UxVD6t1ZJl5n+MBbQUPYU80/kbdOojrA5bMA
	PLUO5GdcDb3U56ebgU8/nfxIoAElYxIc=
X-Received: by 2002:a05:622a:230e:b0:4ff:c08a:52c4 with SMTP id
 d75a77b69052e-50e36b42814mr490117631cf.18.1777067594329; Fri, 24 Apr 2026
 14:53:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <66e3edb75bf1924c650bce43835acc2053d1cf1a.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <66e3edb75bf1924c650bce43835acc2053d1cf1a.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:53:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7GgkSmtOcj5J7ganrAmMWy+f9XwMugU_9ycj_9GkwMqw@mail.gmail.com>
X-Gm-Features: AQROBzBWyOWcIllcqwWWIiWICmgm_ZenfsRGB5Y8YJjwcYJ0DRvuRQ83P3LidZE
Message-ID: <CAPhsuW7GgkSmtOcj5J7ganrAmMWy+f9XwMugU_9ycj_9GkwMqw@mail.gmail.com>
Subject: Re: [PATCH 21/48] klp-build: Validate patch file existence
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BC6FA463999
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2533-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Make sure all patch files actually exist.  Otherwise there can be
> confusing errors later.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

