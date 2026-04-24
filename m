Return-Path: <live-patching+bounces-2545-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YPTID0rr62nhSwAAu9opvQ
	(envelope-from <live-patching+bounces-2545-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:14:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C50463C0E
	for <lists+live-patching@lfdr.de>; Sat, 25 Apr 2026 00:14:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 50B803009831
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0605137BE7C;
	Fri, 24 Apr 2026 22:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np9+rwAB"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7B4B349B1C
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777068868; cv=none; b=HX3xzirkj7+JOhA0QFpD4eLFWCWKx58kxlVeJd5neo6OxGsbMotqhcgUnsrmnMlmXoENDhAUtRRWvWQz7872YVlsOpUZIXCdyt8hVU01B5wZkICcP6DlrqKZ/SHjSJcTBbmxH+2m7tAN3prKLOVPWxIP495vdC2i039WofcGjpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777068868; c=relaxed/simple;
	bh=kCc4lHd+8kN/RzhuTyo2jmpnpu+7HwgZ30dxi+sxgSo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fEx0cVftZ1IPQYbLYfm8Z7+e3jg9zpPoL01cwUgK3acYhGZ5pj3alBtoe5/nbAUDmc/5VBqQ0CGZgnzee6wKw63R4G0ghiDykTVuhMh3d2OdKSH2w8rQtJz4iRicerEiHcIcHLg78KeZVGVoNcXcReBOjpBOqfF/kD3Uk/TPIhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np9+rwAB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7372FC2BCB6
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 22:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777068868;
	bh=kCc4lHd+8kN/RzhuTyo2jmpnpu+7HwgZ30dxi+sxgSo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=np9+rwABSt1kgYzldIye+MIk1F5TKRt0vtT0+rPt/QPpep5Pf3OHoaGY1eU8G5L5g
	 maRh6ydlKqrj+JuDQOHLTRr5maEGUagvwYIb7Q8TThdutzp/BeKzJo85+8yvrZbzWw
	 a/xWnSjDLChymljfUnEV6JT/EdFcbkK90LAPqvLz0C84Fao25GYK3LmK70iAS9W6VK
	 mpu6SYQkDdzZ33MmHE0HJS5eBZjL/q1CpxNde9STtxy4X7g1NtPOzNOSY1ycmBDUFa
	 dLbZboKv8A7dCdchSRTtmAJlpcP8aAg9L5rAlhNqkcK80JpjWiuRYAHDhgks8OU2v4
	 jAklyNf3KY/dQ==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8b038a00370so69395846d6.1
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 15:14:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Gqf10sY0rlGm288QOGD5ea4NkxPsPVvyztXXUoH2CCXuTG6Kl7CSg2WW9stnkTOcKES8ea66qUF3ZsXYH@vger.kernel.org
X-Gm-Message-State: AOJu0YzK5bCDBl/8vwGXMlW2cYtnOQ1XgsSofj7eyDPRy2ZO45Y1OMjo
	zbGg7PAnYitvMhWY8Q1JBSeqDSJvxJLCc7H96tK0sdMwZfp1EjPJsoRI+FTJ6Wp6Djuu8zEXsnk
	oCX1h8272WytoLguSFo19NDPbRR5yRaE=
X-Received: by 2002:ad4:5bce:0:b0:8b0:2d20:ff8e with SMTP id
 6a1803df08f44-8b02d2101acmr446877456d6.25.1777068867635; Fri, 24 Apr 2026
 15:14:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <ab7a6a65b9139aee9f52829048be928ca0c062b8.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <ab7a6a65b9139aee9f52829048be928ca0c062b8.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 15:14:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4yPvnQ3fYMp+K1vBeZE9WCGkWi2eYiixk0CH6kO3Kx5w@mail.gmail.com>
X-Gm-Features: AQROBzArmbNX469GChAv7XPAlkUZprMO6vyJIRI6Q8mijkFNZ33j49U-Hcd9dbk
Message-ID: <CAPhsuW4yPvnQ3fYMp+K1vBeZE9WCGkWi2eYiixk0CH6kO3Kx5w@mail.gmail.com>
Subject: Re: [PATCH 33/48] objtool/klp: Extricate checksum calculation from validate_branch()
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 45C50463C0E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2545-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> In preparation for porting the checksum code to other arches, make its
> functionality independent from the CFG reverse engineering code.
>
> Move it into a standalone calculate_checksums() function which iterates
> all functions and instructions directly, rather than being called inline
> from do_validate_branch().
>
> Since checksum_update_insn() is no longer called during CFG traversal,
> it needs to manually iterate the alternatives.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

