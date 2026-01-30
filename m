Return-Path: <live-patching+bounces-1946-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0MXkL7UYfWkhQQIAu9opvQ
	(envelope-from <live-patching+bounces-1946-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:46:45 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B714BE827
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:46:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BCB71301F9F6
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D367344D81;
	Fri, 30 Jan 2026 20:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="epnjIj3I"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0E32FE071
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769805991; cv=none; b=PC778oAho+Q9bMk4WvVw9GJn2IGXzSCrKAMiiLw8v4s8JkQd+okcBsZ4hZq5AyDTXYItwBuqgfBzxB2v6eO5og/DWd20xH8d0zqhzbdG5rMlZCY1Jo93OuHlsvwVCqNZmMw9ohkXU5xBru8C+8whHfs7LJ4rblOv/2ooqpyrOP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769805991; c=relaxed/simple;
	bh=rYfyQAsJwOjblQq6r/NfwVINY8g8obQouOwfoVGonE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aB3WlT9ayHbLD3AU/GJTRjhuSJBS5EN5EKGlGXlDbVrgpB72tbr7tCb70CrnlKYHkPyhWNSOWKAHxK6PrpijSOQSrGnrccqEya8BWNCVm5UGJuVW0jwsNzZfT/KmzNjQSpZJ7tM+6QT65InxbHTdKze/91hgIF0UZvLDM1e+c94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=epnjIj3I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147DAC4CEF7
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 20:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769805991;
	bh=rYfyQAsJwOjblQq6r/NfwVINY8g8obQouOwfoVGonE4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=epnjIj3I8NSxOkcFN9nMREj++YsMWSG7eP81iEQml+XaU8SiC+reU5jfGyarJQCU8
	 eizn8J0fl+WIIEz+xpmQsr7p0V7VMqvYP2c5sGVrY3WvCcczSSe6yNlaJoUnJ3CCvV
	 9+l5Ocb/p+6rKmD7B1GRvSYcnPDJSdP2CS7fSIcJiI09EPY46sPY2VydtZg7+XSKMm
	 HKLJADyySNugUWIUTob9pFFC0T6y296lcGT4sPrTYZyTkJGbHDuwrO+dVYI1i6UhLw
	 3aUPcmPh7hGET+oblQsx0/ZmFwu3ueQrAE/IsCVWlJnJYoyqqRX936JGlyzkCHCQEK
	 wxyx5eKt9fxLA==
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8c7120353f1so253833485a.3
        for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 12:46:31 -0800 (PST)
X-Gm-Message-State: AOJu0Yyuzzqw2fOj+m+ELLu5/clrcpDU+BjTk+0v7WyG3+FEHolvEQXV
	Ayv0FsBsrg3pUG9a5V2yHgitKNMDS/9BZFI9LnKsaf83WAgZ4YEZBSRkHZC3RrYcjmhJQtOSD5A
	Oti5IgAlzUTeujj04TsEq8BhUd9ob7S0=
X-Received: by 2002:ac8:5781:0:b0:503:2f21:6355 with SMTP id
 d75a77b69052e-505d21a05b2mr59725581cf.34.1769805990242; Fri, 30 Jan 2026
 12:46:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com> <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
 <aX0RBzV5X1lgQ2ec@redhat.com>
In-Reply-To: <aX0RBzV5X1lgQ2ec@redhat.com>
From: Song Liu <song@kernel.org>
Date: Fri, 30 Jan 2026 12:46:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW60Gqht9QUEvW1PyMOORM=oWrWiJmfFF8Q+aEgX0DqQXQ@mail.gmail.com>
X-Gm-Features: AZwV_QgC4VQZg_AqumC5k87a7ppt4OsgTThvd9MfLFkfaU6HGgdo7CGv25rlIxk
Message-ID: <CAPhsuW60Gqht9QUEvW1PyMOORM=oWrWiJmfFF8Q+aEgX0DqQXQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1946-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2B714BE827
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 12:14=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.=
com> wrote:
>
> On Fri, Jan 30, 2026 at 11:58:06AM -0800, Song Liu wrote:
> > On Fri, Jan 30, 2026 at 10:00=E2=80=AFAM Joe Lawrence <joe.lawrence@red=
hat.com> wrote:
> > [...]
> > > @@ -807,6 +906,8 @@ build_patch_module() {
> > >  process_args "$@"
> > >  do_init
> > >
> > > +maybe_rebase_patches
> > > +
> > >  if (( SHORT_CIRCUIT <=3D 1 )); then
> >
> > I think we should call maybe_rebase_patches within this
> > if condition.
> >
>
> Hi Song,
>
> Ah yeah I stumbled on this, probably overthinking it:
>
>   - we want to validate rebased patches (when requested)
>   - validate_patches() isn't really required for step 1 (building the
>     original kernel) but ...
>   - it's nice to check the patches before going off and building a full
>     kernel
>   - the patches are needed in step 2 (building the patched kernel) but ..=
.
>   - patch validation occurs in step 1

Hmm.. I see your point now.

> so given the way the short circuiting works, I didn't see a good way to
> fold it in there.  The user might want to jump right to building the
> patched kernel with patch rebasing.  Maybe that's not valid thinking if
> the rebase occurs in step 1 and they are left behind in klp-tmp/ (so
> jumping to step 2 will just use the patches in the scratch dir and not
> command line?).  It's Friday, maybe I'm missing something obvious? :)

Maybe we should add another SHORT_CIRCUIT level for the validate
and rebase step? It could be step 0, or we can shift all existing steps.

Thanks,
Song

