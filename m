Return-Path: <live-patching+bounces-2498-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CEHDMdt6mlBzQIAu9opvQ
	(envelope-from <live-patching+bounces-2498-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:06:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B30F345666E
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 21:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 56E9730651E9
	for <lists+live-patching@lfdr.de>; Thu, 23 Apr 2026 19:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1764E3932D0;
	Thu, 23 Apr 2026 19:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N50apbYn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD21B392C4C
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 19:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776971115; cv=none; b=jKuplApsluqPxGJc1pUlNe9uBoaX+brdEyDhm5K7kAtwW+XFN6pr8srRM5VG6ED2FE6wmCJNaPokC5g/2JYwVtwcbQHJZmshLckp8Oxyvlepu9KlPJwWXAkukCtlZ2ukhu0fMXIVNpf7hdvL/0lJ8tkdFbSLlJ3IerU9/bIbehA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776971115; c=relaxed/simple;
	bh=KJg0MuvpzYaTDnJwC2eF2zvLrkJsMkYi4MoNb979M34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bRmfbcOBnzkQCnlf1yNbELXTek5ZPEspXoT0LBT/PLlrOmMsW3Los3m6DL6jV2hMdDXheDwC++R/DAjm6yQZa+ELGq9lmD2NvYAW4WtKfZDqxKn1DoG17JLaCt6vyvLQnetcQ+fBDjJcI0Gz5OFtRCHzNXQCkhzt/HrvJyclLkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N50apbYn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFB7C2BCB7
	for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 19:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776971115;
	bh=KJg0MuvpzYaTDnJwC2eF2zvLrkJsMkYi4MoNb979M34=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N50apbYn93hInXeOgevw5ib3woMCiK07pQrFXIM0l04PbFsQ6fPb6jxzUx79rWjMS
	 qYtxVrom3v18Oga6Qj633QM0ulu1UhDjmWDc0CB627bA60bHYDrUSMN4ywHZeTMHZu
	 1GXo+DCuF/h7JgnVMkis0ondPLu23o+KLfS12aJ0gM2XnYV/EwJD5wZCCfEHmrJBCZ
	 AZKcIEZgUlPQMSMBb9S6gQhdPs8EvB1M8ZcpgZXlfuGDE4qIXd2Kv8fa9YsYsP9JNY
	 vbi2yDDZ4HH9Ax8EzR4F0TTu6nSDF5ZUUsiE5fRBwMy6CcHmL6ORVFxZpv4Ak4GPBt
	 AVoMbiNbVSYcg==
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5637886c92aso2836173e0c.0
        for <live-patching@vger.kernel.org>; Thu, 23 Apr 2026 12:05:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ93hYqjmcelZKMyNZwhb9la28vxv5UVBExK3xKUiNYjA5x3qUbmlXAhLGImwP9SMUVdxWois/bJxGFsxq6O@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx1QghsRlsUOwkhLrPd1l49NibdIJEn7bo968bQyLqODnEseVC
	rkF7+kYeT5SyoEGSZ1NJyBjZBXlpw5bgDqzL4PO9KBMSC7l1hUUqOOvgNDvkNFmOrjF72vRWaak
	dpw83V+ww3fY8C2KOvr06kc3QLzEH0zY=
X-Received: by 2002:a05:6122:4a13:20b0:56f:63db:2072 with SMTP id
 71dfb90a1353d-56fa59b8a4emr11725100e0c.10.1776971114842; Thu, 23 Apr 2026
 12:05:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <93c7c80130375edd22874a57cdea132b0edbb0e4.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <93c7c80130375edd22874a57cdea132b0edbb0e4.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Apr 2026 12:05:03 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com>
X-Gm-Features: AQROBzC2qcQyiVFJWkk_xu1Iir4Bg0C7EzaGkf-GYBvNboJNxPkZM59ERresfq8
Message-ID: <CAPhsuW6_FzbAeqOduv56jZEk2E1xm+RqAxOHdekUHJwezvGOyw@mail.gmail.com>
Subject: Re: [PATCH 04/48] objtool/klp: Ignore __UNIQUE_ID_*() PCI stub functions
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2498-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B30F345666E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> With Clang LTO enabled, DECLARE_PCI_FIXUP_SECTION() uses __UNIQUE_ID()
> to generate uniquely named wrapper functions, which are being reported
> as new functions and unnecessarily included in the patch module:
>
>   vmlinux.o: new function: __UNIQUE_ID_quirk_f0_vpd_link_661
>
> These stub functions only exist to make the compiler happy.  Just ignore
> them along with any other dont_correlate() symbols.  Note that
> dont_correlate() already includes prefix functions.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

The actual change appears to be much bigger than the subject line.
Maybe rephrase it a bit?

> ---
>  tools/objtool/klp-diff.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index 36753eeba58c..ea9ccf8c4ea9 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -786,7 +786,7 @@ static int mark_changed_functions(struct elfs *e)
>
>         /* Find changed functions */
>         for_each_sym(e->orig, sym_orig) {
> -               if (!is_func_sym(sym_orig) || is_prefix_func(sym_orig))
> +               if (!is_func_sym(sym_orig) || dont_correlate(sym_orig))
>                         continue;
>
>                 patched_sym =3D sym_orig->twin;
> @@ -802,7 +802,7 @@ static int mark_changed_functions(struct elfs *e)
>
>         /* Find added functions and print them */
>         for_each_sym(e->patched, patched_sym) {
> -               if (!is_func_sym(patched_sym) || is_prefix_func(patched_s=
ym))
> +               if (!is_func_sym(patched_sym) || dont_correlate(patched_s=
ym))
>                         continue;
>
>                 if (!patched_sym->twin) {
> --
> 2.53.0
>

