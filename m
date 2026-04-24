Return-Path: <live-patching+bounces-2536-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eO1OGU/n62nNSgAAu9opvQ
	(envelope-from <live-patching+bounces-2536-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:57:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 154AE463A0F
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6795E30160FA
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D970537D115;
	Fri, 24 Apr 2026 21:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RnIu1TYu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CEB37B00F
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777067835; cv=none; b=khDQZH7qDzq3JHcr4jRef9whWtKQz1gzNcMk/KjAZ3x5Nf7zdtulEHEXvH8GMRXo5TdkeQp7U+7MySPRlvQSaNacVLETVwMbJ5XDybz7xQBbiO8N4ktoc+Z6chY4hxDo5tqySDiiFAhJ9RaZb7Vj2+7e7qtxz1tnCgVDjrNT0oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777067835; c=relaxed/simple;
	bh=44M8G2DDAd1IPou56ZqD1cJuIXOhd0ZhJSYWhxQahaI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HAMxdOO212LnEJBrrf6Vaz8wGZgxNPSx7/j7+zF+avE9tf62Qt57EthGvHZmd4WMcZF5dY7VxDrGkboGikZehLC4XSaHcY/6ngzYuSYtYLJCc6HDyXSeu8CnZdCeiEpetmNvGGiIphCS6499S4uP0M9imFNgCw72nAA++RNLmz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RnIu1TYu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E7C4AF0B
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777067835;
	bh=44M8G2DDAd1IPou56ZqD1cJuIXOhd0ZhJSYWhxQahaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RnIu1TYuTLIdIXII5dhnfj3JwG44A0sZ8KvWQM36AaXVQVDBYJ4bMkk+zYYY594WJ
	 FWhbe0GmkOFqtCCpJZC2seLdB0yNe2oX/g8YKg/PWvmnJWGbuM4nwJKmt/gAYrmM9B
	 QI0bD990J9OwXmIJbinyXFDVykWd09jkaGgOthz8JvLAqIH/6RW8iQb0QhZtuFEnkQ
	 PtPZMkNtUMC091GyxNTHwW0yhDSOO4LVV29vJ5o0CpF91jsyWyAMayIeClQbMXqmP6
	 yPt5VNWjNrBsjmOmmo9SfOVxh7YHbzMR/UdCGPsz7hUQXS2lD/diaWMVn6J7ih45OO
	 j1hF1bK/cW/gg==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d6b9bca48so32223781cf.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:57:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ935QCZgclWCJtw4UR3xi0fFxFxFKyTVm5S/MmGamiq2OJTLPOom+HsvQ56LzjANVHGXtBTA6rBY7kHJJlu@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Ibf9uT42scMRa/ZVpuqHh6ysoZOZJm5Nt6fx5+jHkuowkPTw
	s2+LpiprEvOFth2TSEhxULvgkszBuXmOIb6rnx3Hwd97vLH1yP7Ycrpab4DUksWvwZzavVz2dL/
	CS18b2lLm9LeH5hOGUSLAN6TcaYHeE8A=
X-Received: by 2002:a05:622a:4c17:b0:50d:736a:6259 with SMTP id
 d75a77b69052e-50e36828161mr485599541cf.3.1777067834271; Fri, 24 Apr 2026
 14:57:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <b3c113988fbc73f0a988c5cc41cd009cb09a4ed3.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <b3c113988fbc73f0a988c5cc41cd009cb09a4ed3.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:57:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6xbWD=KTs=kD-XpHGwkTEirc=deufm9wjHjbYtPc52Kg@mail.gmail.com>
X-Gm-Features: AQROBzDjFrZsi-2DmknrJStHNm7SvqzgrX0FPaprytokb7AMiZOsLi2qf9a3Tzs
Message-ID: <CAPhsuW6xbWD=KTs=kD-XpHGwkTEirc=deufm9wjHjbYtPc52Kg@mail.gmail.com>
Subject: Re: [PATCH 24/48] klp-build: Reject patches to vDSO
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 154AE463A0F
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
	TAGGED_FROM(0.00)[bounces-2536-lists,live-patching=lfdr.de];
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
> vDSO code runs in userspace and can't be livepatched.  Such patches also
> cause spurious "new function" errors due to generated files like
> vdso*-image.c having unstable line numbers across builds.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

