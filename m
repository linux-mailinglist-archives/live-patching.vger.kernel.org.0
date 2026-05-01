Return-Path: <live-patching+bounces-2685-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UEBMMn+X9GnqCgIAu9opvQ
	(envelope-from <live-patching+bounces-2685-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 14:07:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E22024AC348
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 14:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0AD2300C936
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 12:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967BE39FCC8;
	Fri,  1 May 2026 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aLPRA+Hx"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BCE33CE92
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 12:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777637242; cv=none; b=pzt2m36nCahjLAFzxCRLaC9+U6bqbKQN1IR1mGzAc84I0ohwuzBAhCj9jFdZM8OSye9KuJMF9jnjc515/oK3+F5EuSRG6ELCRmUl+ol6Gc3/RlVP4pXIP+A/da+HHG4WR7JsqdrLlqBPh0N2PZsKCm06U8yVIpHurg6CK5EPtHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777637242; c=relaxed/simple;
	bh=vLzg6K724O3WBnQdU3VJjcbFlkyG86EKEkMglLS3WPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uIj6MhqNXGxmwXD8urCKwm8GEXerSeL017F8fpbR7TxXAV9vAt90Voj4/DXv4hxLVSMXfzUYi4G9IjCZnz/zY/s+i9q1STGBB8NffLPgndefe4jSTA2fMYtfnmucnVe9WScXAkTlH0dmho/fpHfwAt1oyPG6ALbnk/gO0MpEFII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aLPRA+Hx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54CBEC2BCB4
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 12:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777637242;
	bh=vLzg6K724O3WBnQdU3VJjcbFlkyG86EKEkMglLS3WPY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aLPRA+Hx/P3NWxvejHS3sr6O0ra71kDXKJy7ZC5noufR8yQoBOZKdii8ltI1zEHQ1
	 2nlwzSzL3J8oNHL/yUYSR/eUgCXgPSTBgzPhwmPUJHQ0SMBppE4etpwD7PjEo5cYn/
	 Ei8gdUd2UFdP61/UUOc4pcMfcV01DNarkkRfROL2uJ4kFuFkjh1r0N1koLAwbL3dE8
	 6IOLvr3ROUu4U4Y9Jt1RjSpqanyD90ogeOoXAuW27LFY4I//2Y/FDxPrSBYQognI1g
	 SvDXfntmf8WbuBQLDNvkRNl4hKDQm0Rigm/5AvDlwTLNfp+rVzQdRzYQv/zszhzbwh
	 vTz1tYXTPW2OQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8c70b5594f4so190260785a.1
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 05:07:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8e6OXQO0E2hmp/kuNRjCMXdQIdGBtUhsRjNQMpC3Zrt/YUSeASloIGcSKTBtO5CEuF0z5AC5YrE94n31KA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+26HjtsDaGbjG0gNPHHMm6xCryYI1YdTr0BwbTMiatovhFCyo
	ImWCv/L9FEflk59iFwXDb+dr1qd4aF+P3WFPnY1pYa5VORh6KoZYXrbj1vx6iSdmVqPOdHKZagB
	asG7ljC351TbsLLng/e65yAabkTr1PuU=
X-Received: by 2002:a05:620a:460a:b0:8d6:6db0:88de with SMTP id
 af79cd13be357-8fabbda6a40mr845838185a.44.1777637241556; Fri, 01 May 2026
 05:07:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <27fcb5a17cc7b6821d8b1c4b9812ebb5b4ee6a5c.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <27fcb5a17cc7b6821d8b1c4b9812ebb5b4ee6a5c.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 13:07:08 +0100
X-Gmail-Original-Message-ID: <CAPhsuW7Pmxt5MbNtmUWcpWxHBLhVK6TLocOmuEkJtHUBkmxueA@mail.gmail.com>
X-Gm-Features: AVHnY4LbNxT6noq7tHhfhXv5hfXEee0PL65aXaUTk3Jd60I3H8-J-6RnnE6SW5o
Message-ID: <CAPhsuW7Pmxt5MbNtmUWcpWxHBLhVK6TLocOmuEkJtHUBkmxueA@mail.gmail.com>
Subject: Re: [PATCH v2 46/53] objtool/klp: Rewrite symbol correlation algorithm
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E22024AC348
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2685-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Rewrite the symbol correlation code, using a tiered list of
> deterministic strategies in a loop.  For duplicately named symbols, each
> tier applies a filter with the goal of finding a 1:1 deterministic
> correlation between the original and patched version of the symbol.
>
> The three matching strategies are:
>
>   find_twin(): A funnel of progressively tighter filters.  Candidates
>   with the same demangled name are counted at four levels: name, scope
>   (local-vs-global), file (strict file association), and checksum
>   (unchanged functions).  The widest level that yields a 1:1 match wins,
>   narrower levels are only tried when the wider level is ambiguous.
>
>   find_twin_suffixed(): Uses already-correlated LLVM symbol pairs to map
>   .llvm.<hash> suffixes from orig to patched.  Because all promoted
>   symbols from the same TU share the same hash, one correlated pair
>   seeds the mapping for the entire TU.
>
>   find_twin_positional(): Last resort, matches symbols by position among
>   same-named candidates, similar to livepatch sympos.  Used for data
>   objects like __quirk variables where no deterministic filter can
>   distinguish the candidates.
>
> Overall this works much better than the existing algorithm, particularly
> with LTO kernels.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

Thanks for improving the correlation algorithm and adding detailed
comments about all these scenarios!

