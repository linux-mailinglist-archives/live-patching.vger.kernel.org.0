Return-Path: <live-patching+bounces-1952-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKi6JsU8fWl5RAIAu9opvQ
	(envelope-from <live-patching+bounces-1952-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:20:37 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F23A1BF59D
	for <lists+live-patching@lfdr.de>; Sat, 31 Jan 2026 00:20:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 87C363035D67
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 23:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E548436826D;
	Fri, 30 Jan 2026 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rzraobr9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22841EB5F8
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769815234; cv=none; b=TusmDcKhLiouWT5UHMmYee1FSjOs7i0LgpUof4nidn68OwOOvHD4LIUbPidxzvGz+K8AKpvBTYbBYgid6aUrscw618cFXxsj+Gr5h8oqThunRCa468DH5NrYg4Ms7n64G1JaVuNVAliipO33iYZYg79S/+sO4Bm1uMBKFVrqcM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769815234; c=relaxed/simple;
	bh=FnIJfVKnRZreMiEmXBchXc4ZHJ39BxChTJreSo+I1eg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d3BR11oBezKzDJdaQ5igy4GtWbcwCGRmrJ5prK60WIuCrCmY66Si/Lsei7erBxc6yKllN362GBcxiShpOZRdtSQXWFW5ql4YYptlrEfR1ahbZCGIWrGdwTlXrjB9DfNc6e788WMAVc/pWPMD5JRq1twlw2NlixCFLfgjUgBeIQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rzraobr9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E80C4AF09
	for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769815234;
	bh=FnIJfVKnRZreMiEmXBchXc4ZHJ39BxChTJreSo+I1eg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rzraobr9B85fuChcqlDtexLvyF8R8QuHp5bvCGazG5vYKORvk9L212gPeIuO5Pli+
	 z+iV4D6AVBjav275D0r2qZn+QLwZCO3BT25/rp3yuTIwyQFhT7izck9d9S6mNk4ZeM
	 R46d3tzISJFGHvsrBe7V/SbRABDwTpAbgXcDheXRIGsGLl7eBq8x5tjS/KHfxpmG6R
	 x+OBFksJ3eT9o4TBuOWrrBMkrCRgTbOdkEFYAhmWqT2YA6QWUkQ9KtJ5XOKnmbooO0
	 bx/gny0XZYr1JnJ8TJe1r9deaJErp3QXDz7ENHH9+o9asnhKT0Sy46N2D5+c2H1HbS
	 xD0hHIgUi/C6g==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-894774491deso35225576d6.2
        for <live-patching@vger.kernel.org>; Fri, 30 Jan 2026 15:20:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqi5L8SQsfVUPmKtd53+GeNIWp6PwyJUr2RdIJr5JrhJQt7xfCXV2Js5n2aBktpSiZcjfBbVKhSxcS0jJp@vger.kernel.org
X-Gm-Message-State: AOJu0YxiB4p7fTSxRoJ+34dJq5U/P+aXYEmWtSM/DTnBlojwnRlhDfLA
	Y+tPvtHZobudCW07nfpx/yifB8KK67bNvrShFyyNCh7+DwpgeckxE6cilYygVY7nWO8YnMNROhY
	pNvkq2o/MQrSUHwn3Z7bTBlZksMMIGP0=
X-Received: by 2002:ad4:596b:0:b0:890:808f:c245 with SMTP id
 6a1803df08f44-894e9fa0ea1mr70839896d6.22.1769815233473; Fri, 30 Jan 2026
 15:20:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-5-joe.lawrence@redhat.com> <CAPhsuW59dfVk0hVPFWjgvEifUwviFvnCcMZFGMeZfrw3LJaRZA@mail.gmail.com>
 <aX0RBzV5X1lgQ2ec@redhat.com> <CAPhsuW60Gqht9QUEvW1PyMOORM=oWrWiJmfFF8Q+aEgX0DqQXQ@mail.gmail.com>
 <47mvnqxh6mc6twwmkrcfmmhnyo3ujsab6tkotvuf2jmsupveib@sf65ms5pp4de>
In-Reply-To: <47mvnqxh6mc6twwmkrcfmmhnyo3ujsab6tkotvuf2jmsupveib@sf65ms5pp4de>
From: Song Liu <song@kernel.org>
Date: Fri, 30 Jan 2026 15:20:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6UwF+JAUGHpokSJ=sMJzhxZixdPZHznfdpdWioH2+Cwg@mail.gmail.com>
X-Gm-Features: AZwV_QjuWetH3vxj58A2u7nKsL0iDLs4t0X3AxNtEgZeeLRxEyyoPyr56WtTqII
Message-ID: <CAPhsuW6UwF+JAUGHpokSJ=sMJzhxZixdPZHznfdpdWioH2+Cwg@mail.gmail.com>
Subject: Re: [PATCH 4/5] objtool/klp: add -z/--fuzz patch rebasing option
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, 
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
	TAGGED_FROM(0.00)[bounces-1952-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F23A1BF59D
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 2:54=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Fri, Jan 30, 2026 at 12:46:19PM -0800, Song Liu wrote:
> > On Fri, Jan 30, 2026 at 12:14=E2=80=AFPM Joe Lawrence <joe.lawrence@red=
hat.com> wrote:
> > >
> > > On Fri, Jan 30, 2026 at 11:58:06AM -0800, Song Liu wrote:
> > > > On Fri, Jan 30, 2026 at 10:00=E2=80=AFAM Joe Lawrence <joe.lawrence=
@redhat.com> wrote:
> > > > [...]
> > > > > @@ -807,6 +906,8 @@ build_patch_module() {
> > > > >  process_args "$@"
> > > > >  do_init
> > > > >
> > > > > +maybe_rebase_patches
> > > > > +
> > > > >  if (( SHORT_CIRCUIT <=3D 1 )); then
> > > >
> > > > I think we should call maybe_rebase_patches within this
> > > > if condition.
> > > >
> > >
> > > Hi Song,
> > >
> > > Ah yeah I stumbled on this, probably overthinking it:
> > >
> > >   - we want to validate rebased patches (when requested)
> > >   - validate_patches() isn't really required for step 1 (building the
> > >     original kernel) but ...
> > >   - it's nice to check the patches before going off and building a fu=
ll
> > >     kernel
> > >   - the patches are needed in step 2 (building the patched kernel) bu=
t ...
> > >   - patch validation occurs in step 1
> >
> > Hmm.. I see your point now.
> >
> > > so given the way the short circuiting works, I didn't see a good way =
to
> > > fold it in there.  The user might want to jump right to building the
> > > patched kernel with patch rebasing.  Maybe that's not valid thinking =
if
> > > the rebase occurs in step 1 and they are left behind in klp-tmp/ (so
> > > jumping to step 2 will just use the patches in the scratch dir and no=
t
> > > command line?).  It's Friday, maybe I'm missing something obvious? :)
> >
> > Maybe we should add another SHORT_CIRCUIT level for the validate
> > and rebase step? It could be step 0, or we can shift all existing steps=
.
>
> I don't see how that solves the problem?  For --short-circuit=3D1 and
> --short-circuit=3D2 we still want to validate and rebase the patches
> because they are used in step 2.  But as Joe mentioned, that can be done
> before step 1 to catch any patch errors quickly.
>
> Something like this?
>
> if (( SHORT_CIRCUIT <=3D 2 )); then
>         status "Validating patch(es)"
>         validate_patches
>         fix_patches     # including fixing fuzz???
> fi

I was thinking to change the above as
   if (( SHORT_CIRCUIT <=3D 0 ))

Then we can save the fixed version of all the patches.

But I think "SHORT_CIRCUIT <=3D 2" is cleaner, so this version is better.

Thanks,
Song

