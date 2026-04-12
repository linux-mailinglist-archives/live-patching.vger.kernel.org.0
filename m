Return-Path: <live-patching+bounces-2332-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGzvKGCZ22mtDwkAu9opvQ
	(envelope-from <live-patching+bounces-2332-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 15:08:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E4A3A3E3ED8
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 15:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 55C4E3003ED4
	for <lists+live-patching@lfdr.de>; Sun, 12 Apr 2026 13:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FDF33F361;
	Sun, 12 Apr 2026 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuLJlfN2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8659054763
	for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775999324; cv=pass; b=sC6hGIi/pJbeZSJ0HvJc+BiV7wjDsSpHtLd28/cxhdK+2eg6B+vmoSaFB0qvd/+w4LocP3sm4sb8+iemnS6Ox4OihHYz2nikk755B90nOT8gicgeRsCT1QGlzkuqRanGKAAftlgItSG80JPUa8X9Ys9eE6g8WFeIKDpcyytiaLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775999324; c=relaxed/simple;
	bh=MhNSVDq+Mp4atqhKE+k2G9tvL4hBYd8ILox5fx+oqq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GNpk/6iuc03vXpdXaC0bV6s5ELGN+FijecyzWUfsXjnk5EiqxZa35VP+Y93ghrhxMklNrIcWs3C4/aMDBz735Rq6C/XNb0LBLzjNo7BGIfxpvlYZPlCSz+NfLcqXJdOHIATG0n2LTEutWhU14892i4g36eT1KTBgRioG9qbMYR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kuLJlfN2; arc=pass smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79ab3e26cceso32041977b3.3
        for <live-patching@vger.kernel.org>; Sun, 12 Apr 2026 06:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775999323; cv=none;
        d=google.com; s=arc-20240605;
        b=SweKRK39ha0c1Y+H3ga2WdMIEs9SqzQsALofE7m0oqVTLyT69uqQ6trP/Uq2P9R5dw
         D3DIkDXmzY7vnbII0KEgvyVaztFcgSIsWZyWWq/9B+8mKvDLcRqckmKKq3+8KlgJti3/
         v+g1QxcjuZ+Z2haQxWa94ADh7eDxOThvDTpWqJeMx7L+drJOnSKQTaF/eSAdezSlas+y
         k+1iWcRj2MJUmPEO4jC73RgSOqDkrlCP9K+JVx/oXRSCbCiPXJV25ATpnmtsK68+0jv+
         YJVNbD2PZIqXC5XJrlOmBY9qf3IUg0HIMyYeArhYZRXNufqj803gmscouZzSacQxMhkq
         GVrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MhNSVDq+Mp4atqhKE+k2G9tvL4hBYd8ILox5fx+oqq8=;
        fh=n85Bhz0rfZzsFV+UaaB5Dn1FQFYy3SC/NsCru/O57Mo=;
        b=Bwmb5K612Zdq8vcxQH7PynBEsedBD6Oy4QjCBI7mp35T3kC2Z2f8Le0lLEODwvXWHK
         K0AO6OioekkztZfwrSUx6eQ23HMGSFwPqpiU4Il6Q6MkVc5FVobaGJ6vmIo20NJwCUL1
         5jrpHHqNFq1olstP9RFchtaJxc0IOk0aQOJsGJVBjD1to8bvveOJGNWVrSZYJ9Vs29ux
         C6Ey8Yc7UI0lCc43W/1hX5rAofH4wDNNxjShyh75LiQGB26lrRonr0SILLwkQ3LP1oPf
         xbZETpb1y8HwwErCUib+6LhaAsvYj7+NTBpmXufTaInURSzXBEVQzp0zLwDF8UWCBfk2
         2svA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775999323; x=1776604123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhNSVDq+Mp4atqhKE+k2G9tvL4hBYd8ILox5fx+oqq8=;
        b=kuLJlfN2DofUdwT+syoUrQnMLqlZ2KfG0EBZ1q/hifobtYSVUf8KPZ+5/xpeS65+2C
         qyw3K6M4M9KjNrd5JZuGUGe3phaSxvCaCJzvrr7jmZbajOrDNQH310++fEFEenwmy6lB
         Vh9FDFQ/c85PE/z5N72aABXIV1fup6Qaqybice0OBLoS5r2LtVbLd3fkDHyX6a8LMhnj
         +E1+2MLUzdYmAh9HtLus2vxfQUL2HsxFmxvykoosuzJ2IM39eZU44BzhIQk6SSMpi76B
         TTNjs444BUPjEe9kbqlQ6JzCBO87y3LZ0lg9CPvAyTrfY/q4ZCccUdaHwMOX/JPzZIQO
         Yl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775999323; x=1776604123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MhNSVDq+Mp4atqhKE+k2G9tvL4hBYd8ILox5fx+oqq8=;
        b=p11DHslPdmcohhxHLgR2enPyZ9TjPNncqpgui3Pgne+GZ87eoEmPm69nHZA2xQUnnf
         EEdqaNOzeSsoaYGABJYEIpO1eR0uxSLo58ICmczIQEDqHAE4aoFzCR/Q1/UArQVadGo3
         vsKt9sNe5rVbohH+69399AWKklAiMOX4Ah3b5TmCcKmoY8klEhzdW8H3oYPghq5mCxvw
         4uXwverJZ3nNLk27Km6H+GFuHYIvcE9YvsKSwo0/sWRH2FyL4NbI44cEoH4nfJMpJoC9
         AKVJzlklfEk9AdOzyCNwdQfR2lxtngCYvart+SoKcvyPjhB8uU3udkgekfuQKvKwBZHE
         dB9A==
X-Forwarded-Encrypted: i=1; AFNElJ+8nKqPpdGUpgYg/arejESHO9YhVjHnTDFNLzt1n/iA8hzb81xCOFKdEJDUrxz4iKuvWR7fvv2ZiVK0AWuY@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4LvxlEaWiy2pIGEaNgdjPIU7nPWG6ws3+EcB22d1r7II+L1ji
	VfjzsnUgBvTuRT37CJHJgnAGdMuDwTaNTpfMSZgrwIKoqCycjUbqmgVpbIbPNRyyKYBhniKG+7m
	543JTsDHxOkiS6zE0i94WUYTzQaYl/MI=
X-Gm-Gg: AeBDieuKzpWCZ3kcWaTpCFGdeXAc+lW7RUYUlglyES4sKVrCmKACTpNS2JBb9bbwQNd
	fPiMtqZFxZIYZxoJOz6V7epHE409rqOnJR2ORoYCIOHOucJCkRhtF6Icv1VySD/9SoTksLJUzbn
	mmppWvIvP3OsTH5NFXMSMZ9DSbZI2uXwdCv/wlobd62rrP5bbrj4SvN7JnXXlakUU9RnSTQmXny
	+qc75uzmbqlqW2QSYhEtT4O4KVbqajL0pOVwky+jIVhzYR9CVEMDL82KOQ+J0ioXzTuP/plgOIh
	FPqdNaFXqTuuBE0UYxbfraEQ/aktOfnUpViRl2Sz
X-Received: by 2002:a05:690c:e645:20b0:7a6:1df5:c99e with SMTP id
 00721157ae682-7af71578411mr84093067b3.30.1775999322635; Sun, 12 Apr 2026
 06:08:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-3-laoar.shao@gmail.com>
 <alpine.LSU.2.21.2604091145340.31526@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2604091145340.31526@pobox.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 12 Apr 2026 21:08:05 +0800
X-Gm-Features: AQROBzAclerg8yyA2S4z9obC58pWuFg4E2KRrI1OP_QkCniXP5TtVECzkOzNGHw
Message-ID: <CALOAHbB5yyj4wJBOZnspVUPfoyumrxHcq2e27hzY881G+Jc_tw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] trace: Allow kprobes to override livepatched functions
To: Miroslav Benes <mbenes@suse.cz>
Cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
	joe.lawrence@redhat.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kpsingh@kernel.org, mattbobrowski@google.com, 
	song@kernel.org, jolsa@kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, eddyz87@gmail.com, memxor@gmail.com, 
	yonghong.song@linux.dev, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2332-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,suse.com,redhat.com,goodmis.org,efficios.com,google.com,iogearbox.net,linux.dev,gmail.com,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E4A3A3E3ED8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 9, 2026 at 5:47=E2=80=AFPM Miroslav Benes <mbenes@suse.cz> wrot=
e:
>
> Hi,
>
> On Thu, 2 Apr 2026, Yafang Shao wrote:
>
> > Introduce the ability for kprobes to override the return values of
> > functions that have been livepatched. This functionality is guarded by =
the
> > CONFIG_KPROBE_OVERRIDE_KLP_FUNC configuration option.
>
> this is imprecise if I read the code correctly. You want to override live
> patch functions, not the original ones which are live patched.

Correct. The BPF program will override the livepatched functions
rather than the original ones.

>
> I also think that if nothing else, it needs to be more specific then just
> checking mod->klp. It should check if a function itself in klp module is
> overridable to keep it as limited as possible.

That is exactly what I am currently implementing in
trace_kprobe_klp_func_overridable().

> Even with that, the
> concerns expressed by the others still apply.

--=20
Regards
Yafang

