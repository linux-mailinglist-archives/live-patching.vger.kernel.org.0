Return-Path: <live-patching+bounces-2688-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKXvLOGZ9GlYCwIAu9opvQ
	(envelope-from <live-patching+bounces-2688-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 14:17:37 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 306354AC4BB
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 14:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A44F5301494A
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 12:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3EE2E7631;
	Fri,  1 May 2026 12:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dzRwETWq"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A6C18FDBE
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 12:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777637853; cv=none; b=nQRQRRTXamj/ymNXUe5zvoz4p0WJvr/dmAyh0NTfoeq/FroQJtccomT7E1yTCPRxP+Xz/oQPEUKb3uXxqQbjQrKr9VHYDzI8UVpgCb0MiSQxO43Ul01VZoHUnQ4QV+yU/WMJBhvTmkYcJsBLDG52pzg2DWIgvapo0WUlhB7RKD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777637853; c=relaxed/simple;
	bh=5W+ArXAzXB8LoymfWYHi31ihdyNT9D9BkWKnCXw9Qyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RA+xZhvCZvS4cZFmsDO1rbbW7Og2U5B4AZ611SXm1ZUEMW009MhJeSUEe1R6XeUoemwc6dktaY4W5RtAPIaN+go1qwsgjB7s3vHz2nAgwiNCeB0dJQ/huAPDPP0SrMXzUO3cqrHNZyt4KJrTT78ikYa6QVay9F/OwYvuK20eTa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dzRwETWq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A27AC2BCF5
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 12:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777637853;
	bh=5W+ArXAzXB8LoymfWYHi31ihdyNT9D9BkWKnCXw9Qyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dzRwETWq6uD7YabHgH5AIPzbl+JP0cTxD2/478VBHrUyy+vRRTUyvlFeV0MB3JNVO
	 O/hI+O32HV//jSlkgkPDJdj3+qf3aQrQLuBRo8VhrSFypVxE6pOhJi37MRJ2vgD5dC
	 0Ps3b5tkfnPITOco3JqbIv6QtCAmUdnCEDVHLS+mC8Z4P/Ae8fjwuRvcE1c8SSNu88
	 PWSy3550CoRgF+gzGom+c/wiWWVfvnPXSCO+Xn3i9GddiIRi5XgPjKtzUvvGBTwwTG
	 A5FFQJlamUgIjgeM0YS8fSUmqp24CYXED+Hes0L6wYNw+53t4+AV4wO8d1XCNO9J8R
	 Dd0pRIscHvIBw==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8a3b0242631so25069526d6.3
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 05:17:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8WpnkBqIgEqcJmJJtzrRdGIKEd8Lp7RBk15DUvJFSwvrVa8qXW+vD/f8Rc1/ddp5UR5LJWl8H9rFe6G47g@vger.kernel.org
X-Gm-Message-State: AOJu0YyALJnhaeZt+3mzvjDJCu2L2puB6Iaa96FZDoUzuF7+M/xpQYil
	9h7zYV9J0a2Pi0esSsvAeasfBkpEKsnAx6nRcImchZcDrBULNX3kFaOjAQJnicTHXgsok6B3L4b
	HWllIfCivkzW2nrOXG4NT3gnHg4roHUE=
X-Received: by 2002:a05:6214:2505:b0:8a5:104b:e361 with SMTP id
 6a1803df08f44-8b547fb1474mr39155856d6.50.1777637852147; Fri, 01 May 2026
 05:17:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <3a6674fa08e32ea6b02adf3e2de185b8ad99b01f.1777575753.git.jpoimboe@kernel.org>
In-Reply-To: <3a6674fa08e32ea6b02adf3e2de185b8ad99b01f.1777575753.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 13:17:18 +0100
X-Gmail-Original-Message-ID: <CAPhsuW7XKO=9cLBDU=DS7HY+MRyQY6-jpbCqO49Et-yV7=x+=A@mail.gmail.com>
X-Gm-Features: AVHnY4L5aTP__qIV035KKp3CP1q1djVmfWUdh8xPrwCiu-V_rxBZt_niG-zL8sc
Message-ID: <CAPhsuW7XKO=9cLBDU=DS7HY+MRyQY6-jpbCqO49Et-yV7=x+=A@mail.gmail.com>
Subject: Re: [PATCH v2 51/53] objtool/klp: Fix kCFI prefix finding/cloning
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 306354AC4BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2688-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]

On Fri, May 1, 2026 at 5:09=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> With CFI+CALL_PADDING, Clang places .Ltmp labels at the start of the NOP
> padding (offset 5) between the __cfi_ prefix and the function entry
> point.  get_func_prefix() only checks the immediately previous symbol,
> so the intervening .Ltmp label causes it to miss the __cfi_ prefix
> symbol.
>
> This results in klp-diff not cloning the kCFI type hash into the
> livepatch module, causing a CFI failure at module load when calling
> callback functions through indirect calls:
>
>   CFI failure at __klp_enable_patch+0xab/0x140
>     (target: pre_patch_callback+0x0/0x80 [livepatch_combined];
>      expected type: 0xde073954)
>
> Instead of walking backward through the section's symbol list, just use
> find_func_containing() for the byte before the function.  This works now
> that __cfi_ symbols are being grown by objtool to fill the padding.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

