Return-Path: <live-patching+bounces-2534-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHbGHtPm62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2534-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:55:31 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D92224639CC
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:55:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58DB5301AA68
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5D8F3469E7;
	Fri, 24 Apr 2026 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2JySBLK"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C375A336884
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067693; cv=none; b=skXT+kqp6xOj1QZxzOz4E/qhL2ki9FnHK9uns+KGEHRhrSaisFDznBNGlSdJcvkRoW/QVuWtv4pLR0iYuV7VlseALO041paZO1uI+q1Qgb4q8G6ubHR0tWAosZXfv3dTEeuaWUz7XPlpUMqnSHB0zcNBImOjTwJ+N5vheVMofvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067693; c=relaxed/simple;
	bh=tJity11cWUPJZSNRfYTMj9eEKufmd9oWG64yJzSiXAA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nowqjz4Zw9w3ub/BLT6cooQxzmId4QO/zpgWFPE9usTBssgdB5QUCFpjIEYuwkvFDkH2Vu102qaWvV+HpKMUqhfBYpKyn1amt63TpPaomS8l9btYyGUJLZcS2+yI5fwlXn8/wxSOFQ9RzlfqY8uGOVBJ89CjEcoRjAYW+/52bIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q2JySBLK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77451C2BCB0
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067693;
	bh=tJity11cWUPJZSNRfYTMj9eEKufmd9oWG64yJzSiXAA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Q2JySBLK2iWhvKd8JV40CWn8c67fIuNNxzmwVJbEXWBkrNI8Q/nNiyDHwgWS4JDQN
	 wDUGQKT4Dz8SAh+E6+WBcIYxs1RpryA6kNLgfGGupAxkR/JLaceXChHXnfK8oGDn4w
	 tPnSmKnO/yj9nUPCX8zp7iJQRNEq9WIgPpmEzlgNFbHI5cX0Xdof9SmfihIlQ0JGrS
	 5ed+dcHcHmmmQYAurhXXoKP07davsuE085CCaX3v8TihHHbvwx2anlCMVuEmnXhfiK
	 jze3XHFf5v3+ETKT9A8lO5m8YozufE20B+5elr07Oq4UNILkve4bk5MqV5Ew8RaZtI
	 hwsYBCxVDZFPA==
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50faf8ed9c5so31133831cf.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:54:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8t0+DU4QOsaIOaD35LfShn79Z7EM0xwjtdnSDxfvKa11eM7xWd0rxZxURFf03ErbCyZZ/n/POh6Z9AJOdV@vger.kernel.org
X-Gm-Message-State: AOJu0YzI+girlbzS5LJMlM04Gwn/8YgAEX3CBek5U6XAXZnseascmm4W
	96T8QetGTjyTZi4zRapUlYcp5Kl0Zi34C+frQabtxz3w35Pev4SYBRDr8TZDU/LI5D33PF0Eidx
	bHTRux9cVxqbPQPbRe/A3gGqEC1vEmPc=
X-Received: by 2002:a05:622a:4c89:b0:50d:89bc:f450 with SMTP id
 d75a77b69052e-50e367fe17fmr481616841cf.11.1777067692705; Fri, 24 Apr 2026
 14:54:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <58c5ac9ae38760beb06e5ddddb742ea54f922371.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <58c5ac9ae38760beb06e5ddddb742ea54f922371.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:54:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7HkX7d__MmmN2vp-CyNtNmUY_X0j=_Ab5ufR1d01Lb0Q@mail.gmail.com>
X-Gm-Features: AQROBzDNISIluGyYTeHa3ueK24gqG8rwvN7z16l5KIeGwb5fBc3as07hwitNnYM
Message-ID: <CAPhsuW7HkX7d__MmmN2vp-CyNtNmUY_X0j=_Ab5ufR1d01Lb0Q@mail.gmail.com>
Subject: Re: [PATCH 22/48] klp-build: Suppress excessive fuzz output by default
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D92224639CC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2534-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> When a patch applies with fuzz, the detailed output from the patch tool
> can be very noisy, especially for big patches.
>
> Suppress the fuzz details by default, while keeping the "applied with
> fuzz" warning.  The noise can be restored with '--verbose'.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

