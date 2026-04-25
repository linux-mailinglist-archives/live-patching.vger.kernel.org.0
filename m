Return-Path: <live-patching+bounces-2554-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4LTQJqgW7GkKUQAAu9opvQ
	(envelope-from <live-patching+bounces-2554-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 03:19:36 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CB74646D1
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 03:19:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 549B53001F95
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 01:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F4E1552FD;
	Sat, 25 Apr 2026 01:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOwaLtCb"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E41942048
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 01:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777079970; cv=none; b=Vf8RkaV4GZdFMNtZ7JiwJuoMVihk3y2EW/8vvXU9iONFcch6tjtHhcxSLU9l89qTwIyvi425RpD0cg4+Ep/SX3dY8DmKXCQcLTZCP9gtHWD3ZHL9MM6j0vr3Fy0KSBM59EJVfMoDSAVso7lSJXDMry3GD3Q1eVyG7n8c+IMe4PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777079970; c=relaxed/simple;
	bh=HwkP74LwzUoFyCqxDhqBx17r+oTr3p4LWDomEJSrRfo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qlevM+5eYqzKH+MrYinzwL36P2MmxFwbdilTqC47Zr62DG7FS4WK/LoM8k4fsiJjNnOeww2KhxYXskwJYwYbomdNHlb2a9c07ZZRdCLIlGJlFo9vh0eTH+SdXEt0qPb80zcwz3EsMCZNpmgEXg80quOu0ey0tDd7TZm46fneaPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOwaLtCb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E39C2BCB9
	for <live-patching@vger.kernel.org>; Sat, 25 Apr 2026 01:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777079970;
	bh=HwkP74LwzUoFyCqxDhqBx17r+oTr3p4LWDomEJSrRfo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FOwaLtCbTqQDLkXhCBg9fvkiq61H5lLenfD/Hu/sBRVd3fXcWQRuWwyezRbUqD2dz
	 VEz9Yuoz3oqx2mB0nQJBsvb8dQXkwDaOuxfG4oQkoup5GB0ysHvfHxck1J5tnSEyIJ
	 zYiDe9qN4TjEqWwkha5OYnmOpY5NrRXOmULjyZfA10rItSNwvPD9wQx1oxgtULiHqr
	 Jhd4yoS+Ss6RlrOHSZ9zwRdGUgO/XIb8NhDkymCHv3tUcJzt7qJAEuOq2XoiKjSXet
	 bZ+tKyrS2J4dNS5quF7kftvVWuor2mmlChEEmVFv0PhTXXQvAOHhDUybK1vQTbBDL1
	 57Q+OQPEvAiyw==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b1f2b7f1bcso63696996d6.1
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 18:19:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9mItJaNvOHKc5fHjOzTra1c99wyN6MTfacJXaoagys2qGWI5HwxteYbkCHkSgZNab3w9QiftnM/TOsIapj@vger.kernel.org
X-Gm-Message-State: AOJu0YwlWS7AzrJxc9X2ZpAsDp63nlbWhYsNfvRe2H8cEwI7oz137F3A
	toFl8h0Tw3OCnFMpyLJ5bPFqZAg24E/sVfxzeWSjtITcxnu6x60+xXZLzbIYsVxghSMWY/S2n0c
	/ongbOzIkGGcviKWS8L91LB/8nQ8DGPs=
X-Received: by 2002:ad4:5f0d:0:b0:8ac:adca:2325 with SMTP id
 6a1803df08f44-8b028693febmr480657166d6.15.1777079969582; Fri, 24 Apr 2026
 18:19:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <c5c4467abea21d4962b4a61c5d6023482e01bd8e.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <c5c4467abea21d4962b4a61c5d6023482e01bd8e.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 18:19:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Ks8tvKNyzpdObx=6K4zjRcpTBB4Es0jp0dRSn1W9rSQ@mail.gmail.com>
X-Gm-Features: AQROBzCuTZofzpQzJ3LMjQ6xlX3VRmi9F2E_7PU4IT8hFE5zG61b1fgD8AQiupw
Message-ID: <CAPhsuW6Ks8tvKNyzpdObx=6K4zjRcpTBB4Es0jp0dRSn1W9rSQ@mail.gmail.com>
Subject: Re: [PATCH 48/48] objtool/klp: Cache dont_correlate() result
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A2CB74646D1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2554-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Cache the dont_correlate() result once per symbol at the start of
> correlate_symbols().  This reduces klp diff time on an arm64 LTO
> vmlinux.o from 2m51s to 35s.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

