Return-Path: <live-patching+bounces-2674-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SOScCVOA9GmXBwIAu9opvQ
	(envelope-from <live-patching+bounces-2674-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:28:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FDE24ABA27
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D78B300CC1B
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69144387372;
	Fri,  1 May 2026 10:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VxDlnoNc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467A737D126
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631312; cv=none; b=Pev00BQZeW9oHm673a0BblCnu2hhRWI1hRb3fy0bXTYMt0mwm+0o2/3IeIf/MX1ZPUeysHNEgEh7/4Z/CjyGKdoRnsWP+/PBsU9yf26dbcpJsq4dIrh1i3yWzHqsg8FyPM1sFULtYjzHSkO7Zf/PlK7dQbHRuz+C+w6d/xV7oa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631312; c=relaxed/simple;
	bh=fxj4/DbMyxJTvqiTulV3+u8K1F8yWbNaMSDRyayDGEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K0hPTqhGlcp+7Mq1PeyS7biCSRw1b1T/etfOqzyjmAI0LHL1vhvrYSyewsKGYyx6wHxtZDU2FUvJ4WD3gfK9H7YnVpOrf4Sw3Y501rAFK2ZbzyImpJbuMyCvcPzsTxysYp3bqDO1nGVfKB1DyrzKtYqH3a4v0DEIO1oJjh/f8Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VxDlnoNc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280B9C2BCB4
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631312;
	bh=fxj4/DbMyxJTvqiTulV3+u8K1F8yWbNaMSDRyayDGEU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VxDlnoNcDpVEa9LdTYlmH8kqtFzJ4EkkyMP1e9T3vlZjFbQbmK/Kjn/zuw0M40SWD
	 VFwupqseTdqQ1f/uMAR8Ft4aoWRNf2Ur0zSP01wVtI6cfZX8TEZqGaO4Odvp0jOGWi
	 raE7LX/5ZCGi1zOYYpZEd3CoiZpBYPAhRmPpmAAl/Zvi+3pxfuTTcdKmkevZc1y90d
	 DxEcoInVVI98geCVW6sPuw1weA1I5pXoqPdjaRA6hP1QRqbORQI5b1hw4cql+d2h7r
	 vCU9JxCkqOtwj5zDx98WXHPu6xr0T2VGhETwfZS69QLbaHwTeb3RVDarx8P2pnN9Ru
	 e16mjrkD+eYVA==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso15984446d6.0
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:28:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+MvH3W2BUgTjbLUMEdg+6VeHEcm/qt4EFG/+2RRLW58A+hxAuAvNJQr52XkOW2pNkBX9l1IJaiskiAm7qr@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb/6lAxCHL6glqd+H5KRHKQosRdiB7SblQL/DlkKVS4Q7rr6X6
	Fln7QAaJm02amsr4k6a+LHAJi3Vtw1UF3ay4iFd+NF/zKWi8ldskmG0B7CmRrHNSHMW18vcpK5E
	QAVfryEj8buqpwymWaet6GvXCxgEd0I0=
X-Received: by 2002:a05:6214:6008:b0:8b1:f8fe:507f with SMTP id
 6a1803df08f44-8b3fe80754cmr92387226d6.46.1777631311358; Fri, 01 May 2026
 03:28:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <cb95eae9cc63ca04f881c69c93eed6bac0c751fe.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <cb95eae9cc63ca04f881c69c93eed6bac0c751fe.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:28:18 +0100
X-Gmail-Original-Message-ID: <CAPhsuW6zujVRNQnY_zqwqzpxb2VFO4HvbQ+jc69StSv=6szc=w@mail.gmail.com>
X-Gm-Features: AVHnY4LutR8Qn2H8QVB_NjDY2fmViMpZkcZ1Efa-fHqK3GIWjfEwjCET8CXBhEk
Message-ID: <CAPhsuW6zujVRNQnY_zqwqzpxb2VFO4HvbQ+jc69StSv=6szc=w@mail.gmail.com>
Subject: Re: [PATCH v2 09/53] objtool: Replace iterator callback with for_each_sym_by_mangled_name()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5FDE24ABA27
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2674-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:08=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Convert the callback-based iterate_sym_by_demangled_name() with a new
> for_each_sym_by_demangled_name() macro.  This eliminates the callback
> struct/function and makes the code more compact and readable.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

