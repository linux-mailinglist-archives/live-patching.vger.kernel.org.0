Return-Path: <live-patching+bounces-2535-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +AwiEBvn62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2535-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:56:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B752F4639EB
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 56D8B30233D1
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFEDB34A788;
	Fri, 24 Apr 2026 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hnaOf+JT"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4E5336884
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067799; cv=none; b=DKlBAHrcE2CAx+2kP2Ii3vGc1COhzj6QJn5aK3Me8507B4lpIA2Ed9QvNXbF78iuDqiK8Vyn9t35JgrbpboPypWFfqdr8XjEpQu24ZVGQZGc5amhbpeolwR9BE1IGuU0C0xFwHrDR7ihmKFkG8Ko+4EnasyljSzh+l8IkZ7cgNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067799; c=relaxed/simple;
	bh=jxpLIumnebzgT/zIq+oPjAKw9qWyiVYkZ9E9qCHOoNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sr5y7H1G5WKUQ/IrcLLAti7y+Pa2XZvB4/SFaDUTONpRKer8l5kHa8eEuKZS8DviJ0M8D/2KEXgM71sGNehmzeFW4b9a3nxXghDCMELOQ/JLa5FNQk/AaxgUHzj3tIfreAyGV+J/3RFYvBXADYj1JdntGq4/CYeaioocmwashgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hnaOf+JT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75225C4AF0B
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067799;
	bh=jxpLIumnebzgT/zIq+oPjAKw9qWyiVYkZ9E9qCHOoNU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hnaOf+JTXFAqDhPY/t5dZF/UUSFylNy6qKPMxRbokp288obTUGdgEk7kHNSg2Uvwv
	 2PqIhWojY2+jzBONaVqQC8kpIzFGq0++R61kFjM0vkNhTHu7F80BHcyRCFngHplWVR
	 MvFAUGeqopADrlN2k0BF14F8F3heDpYik8Il/Ofb2QZZGkmBy9ZZlB4HHuIUzmiqf7
	 WQdp+XRy1TFKE+2P9MZhQlxORtALvyl17EBjzdRGKlePndpHp6/4oL3QVWFUwmuO83
	 xTNEwUHhpGGpOKGzwQY22kAZLLOrvPpzjRawaGuPmnyDc97WPZECv1EhEymD5OlVlu
	 /jbI+lMk8LK4g==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8a151012558so89037636d6.3
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:56:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ90l1pgkbwpsNri/5zv6W0q7+cTB7ocM2BfDMWgNvxu/KxHBO4xmQK+aqEwF9i4Dmu2t0uXPCYTBFBCHES8@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrr8CYt8/sWUkbg8Xgq/0qXS/pwvQNOVmyy2r5EXK+h94zWxWJ
	W8ofC4X5Lx08mQUntO5EEPyPcyr+CDp+j3nUKrhaqSVUwSVJligZU6Gh7gFtdYje7hX9w4I0d0S
	9O8kMjerQPgF5XFDtA58QTKMnEEyGrYc=
X-Received: by 2002:a05:6214:29e9:b0:8ac:b2e1:379d with SMTP id
 6a1803df08f44-8b0280eddcdmr530820176d6.31.1777067798698; Fri, 24 Apr 2026
 14:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <cc513774c7d5063812c66bac421e56e24fccbc42.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <cc513774c7d5063812c66bac421e56e24fccbc42.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:56:27 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6dp_zu2HsefSL65Vx2G_epQn2t9t8M4u9Y2ZdWU5CEgw@mail.gmail.com>
X-Gm-Features: AQROBzDRtWNRPHUoosXlHqJi9uh6r80FDAijk9tmtHFSwPmhEZ_9a4-gzuSqK0I
Message-ID: <CAPhsuW6dp_zu2HsefSL65Vx2G_epQn2t9t8M4u9Y2ZdWU5CEgw@mail.gmail.com>
Subject: Re: [PATCH 23/48] klp-build: Fix patch cleanup on interrupt
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B752F4639EB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2535-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> If a build error occurs and the user hits Ctrl-C while a large patch is
> being reverted during cleanup, the cleanup EXIT trap gets re-triggered
> and tries to re-revert the already partially-reverted patch.  That
> causes 'patch -R' to repeatedly prompt
>
>   "Unreversed patch detected!  Ignore -R? [n]"
>
> for each already-reverted hunk, with no way to break out.
>
> Fix it by adding '--force' to the patch revert command in
> revert_patch(), which causes it to silently ignore already-reverted
> hunks.  And ignore errors, as the cleanup is always best-effort.
>
> For similar reasons, add to APPLIED_PATCHES before (rather than after)
> applying the patch in apply_patch() so an interrupted apply will also
> get cleaned up.
>
> Fixes: d36a7343f4ba ("livepatch/klp-build: switch to GNU patch and recoun=
tdiff")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

