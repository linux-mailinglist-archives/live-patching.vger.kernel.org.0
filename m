Return-Path: <live-patching+bounces-1135-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF16A2D2FD
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 03:15:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A881188CC8D
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 02:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5D954673;
	Sat,  8 Feb 2025 02:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpfNzY1F"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF0F522F;
	Sat,  8 Feb 2025 02:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738980934; cv=none; b=VUa1oSYtR3re4MV0Wwz7+JE4IesCF4W9eY8OyJZUblOUJOhuum02GfkgBtkCnp7xKmB6YVzmHs4LEGh4lqhwsRt/jrss7fkUCFsb77nccqNsSlZtGGy1XelKtXBQT9HMcaIcG+3Ri3bOWslhROt36LQlDNUMnhgpciW9QAJarno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738980934; c=relaxed/simple;
	bh=QDHpeJH1Uv1bjl5fXa6EO9/T9fvpkS0SVHDH1Pls2qE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Op1hQoClG8wD/SZnw8WiCUrBkhqISuU2G/02ILxeBJYkxcyGJQORLCsqMPHP6/nHOormGvp+mg+i6s6WkDv2grp9T5bq/oEEKt5oCzZhwU9sGgvt0CgbNIUZLMK+RDWI5HHmbqHYydsD38HkfBLIrvBg1xO3xfffBFArR5Rj5wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpfNzY1F; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7b6ea711805so428298185a.1;
        Fri, 07 Feb 2025 18:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738980931; x=1739585731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dsWHjhsuSMndYdEkxFI29bs8rM0c/kwVJWav5wz3HN8=;
        b=TpfNzY1FYkG2GN5jvjxg06VhpdKSH3hyG4jeQikvWZzqq2rGCPXJ5NkKP7YJKq0WKh
         5kSg3zIGvrPpVBw9iJUI6a6gS/VOgRKkCyr6SJj75sWJ+O1ZtQPfclK40sHpZt2bRh1B
         rGjb4x+jGIJLnbCO34hZ4wwlxkfZt62/y2AkfeGTZC72k0ejEiHgFnpLJsKY0XaqRPIi
         9MyJ8oOMCwa2z/y7DkovnwVUEQfYWJ57DmDnnvzu2IzGiylYkKmwMOwtzQWPP6EjntEX
         mbFJuCfaQNcSeyDIQ2JbzbiJBggVn+cd3b5R4GP3N119A7jzrKTfvRxCj/fp0Nq6IyOp
         +LFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738980931; x=1739585731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dsWHjhsuSMndYdEkxFI29bs8rM0c/kwVJWav5wz3HN8=;
        b=KXQzfvquZPxY8lmXh6rMb007ce3/KljKbLBAiktrEfJvrP9u98Tdv6bHd+7m5FcE4y
         YnwUruVheXqkVaqGMA+HfdJy8DrxEoZ3VtBAFqKNpQEJCI1m5no33Ay99xBWZvGOpHwT
         8XdyJoFM3taxGXhB7DwgNJl1snjKuPPfigsBkYfz05FXcZ0rHfhrHOVAhiI5JGBlD/gH
         rJl0lGqC8rC1gI3a0RDssW9esa0pT3xG7OTLbx66t5SS3ffEjq35OMRWOjLbL9MLIzsd
         xqju4ZFUKMGNHJEPsoxrlO/7KgsPy5UPHjXSmHf8uXh2fmjiFTbREn3MNZMq/CQ7ag8Y
         HFjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwUkzmR4FmWy9wKTyjKIk4HzWUSpE1QPBWHv1+nKSoAODTg9YqUAvmm8HsoaCkqaYUTVY7WZlDF2JJ5FY=@vger.kernel.org, AJvYcCXoml1J+XGMltAitp0kJfOuahcsf5nXdc6iSzglMi9BI4Y/p9Rc+2DLltg0oWsBx7I21iJzBWR3TLMXlHDwBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHJsIcaxAkZngwXPCvFwZnBAeK77yqJwixxs5hkLTpFaPiRu6e
	JBpZnAM2KDtcPgVhuC8wsNV08sj1w/MPjIGZjCSc5+NffUZpG4Yun38E16QfymCsl6zT7G9v5ft
	UL6CkGSsBKfx9unT8RumD4e/Wd8Q=
X-Gm-Gg: ASbGnctS2AvEelpoAbIo8GWuAkXV4ugTiKeKdAtbVXyGxAaYv9b+RfWFGd9xkUruutc
	NwjAy00g/ektPF5UZao/RZWEhlMnWeXpGq4M/UkAHTqAdYRZgNcAwP5vyv1FySVpjHzumIJAxhA
	==
X-Google-Smtp-Source: AGHT+IH5w3Edi6FHb0d1U7KFzPKZA36R7fxqsmDgE5c+gsxloID4ncYbr9V12BluNg96NPszGrgDuHCodfTGI4twg1o=
X-Received: by 2002:a05:620a:26a1:b0:7b6:d252:b4e4 with SMTP id
 af79cd13be357-7c047c9507cmr1069806685a.53.1738980931444; Fri, 07 Feb 2025
 18:15:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <20250127063526.76687-3-laoar.shao@gmail.com>
 <20250207023116.wx4i3n7ks3q2hfpu@jpoimboe> <CALOAHbB8j6RrpJAyRkzPx2U6YhjWEipRspoQQ_7cvQ+M0zgdXg@mail.gmail.com>
 <Z6XUA7D0eU_YDMVp@pathway.suse.cz>
In-Reply-To: <Z6XUA7D0eU_YDMVp@pathway.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 8 Feb 2025 10:14:55 +0800
X-Gm-Features: AWEUYZmvJcoDPlOAnmZZ-I3g-fT3mE68vPN1MpHan1Pfrgj13_lwhaFU8Q5GOxk
Message-ID: <CALOAHbDhxLfd4KZ2Ge79qu1X33V9ErtW0W+Qi+1t-4RgMeedGA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] livepatch: Implement livepatch hybrid mode
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 5:36=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrote=
:
>
> On Fri 2025-02-07 11:16:45, Yafang Shao wrote:
> > On Fri, Feb 7, 2025 at 10:31=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > > On Mon, Jan 27, 2025 at 02:35:26PM +0800, Yafang Shao wrote:
> > > > - Temporary Loss of Patching
> > > >
> > > >   During the replacement process, the old patch is set to a NOP (no=
-operation)
> > > >   before the new patch is fully applied. This creates a window wher=
e the
> > > >   function temporarily reverts to its original, unpatched state. If=
 the old
> > > >   patch fixed a critical issue (e.g., one that prevented a system p=
anic), the
> > > >   system could become vulnerable to that issue during the transitio=
n.
> > >
> > > Are you saying that atomic replace is not atomic?  If so, this sounds
> > > like another bug.
> >
> > >From my understanding, there=E2=80=99s a window where the original fun=
ction is
> > not patched.
>
> This is a misunderstanding.
>
> > klp_enable_patch
> > + klp_init_patch
> >    + if (patch->replace)
> >           klp_add_nops(patch);  <<<< set all old patches to nop
>
> 1. The "nop" entry is added into the _new_ (to-be-enabled) livepatch,
>    see klp_add_nops(patch). The parameter is the _newly_ enabled patch.
>
> 2. The "nop" entries are added only for functions which are currently
>    livepatched but they are not longer livepatched in the new
>    livepatch, see:
>
> static int klp_add_object_nops(struct klp_patch *patch,
>                                struct klp_object *old_obj)
> {
> [...]
>         klp_for_each_func(old_obj, old_func) {
>                 func =3D klp_find_func(obj, old_func);
>                 if (func)
>                         continue;       <------ Do not allocate nop
>                                                 when the fuction is
>                                                 implemeted in the new
>                                                 livepatch.
>
>                 func =3D klp_alloc_func_nop(old_func, obj);
>                 if (!func)
>                         return -ENOMEM;
>         }
>
>         return 0;
> }

Thanks for your explanation.

>
>
> > + __klp_enable_patch
> >    + klp_patch_object
> >       + klp_patch_func
> >          + ops =3D klp_find_ops(func->old_func);
> >             + if (ops)
> >                    // add the new patch to the func_stack list
> >                    list_add_rcu(&func->stack_node, &ops->func_stack);
> >
> >
> > klp_ftrace_handler
> > + func =3D list_first_or_null_rcu(&ops->func_stack, struct klp_func
>
> 3. You omitted this important part of the code:
>
>         if (unlikely(func->transition)) {
>                 patch_state =3D current->patch_state;
>                 if (patch_state =3D=3D KLP_TRANSITION_UNPATCHED) {
>                         /*
> ---->                    * Use the previously patched version of the func=
tion.
> ---->                    * If no previous patches exist, continue with th=
e
> ---->                    * original function.
>                          */
>                         func =3D list_entry_rcu(func->stack_node.next,
>                                               struct klp_func, stack_node=
);
>
>
>         The condition "patch_state =3D=3D KLP_TRANSITION_UNPATCHED" might
>         be a bit misleading.
>
>         The state "KLP_TRANSITION_UNPATCHED" means that it can't use
>         the code from the "new" livepatch =3D> it has to fallback
>         to the previously used code =3D> previous livepatch.

Understood.

>
>
> > + if (func->nop)
> >        goto unlock;
> > + ftrace_regs_set_instruction_pointer(fregs, (unsigned long)func->new_f=
unc);
>
> > Before the new atomic replace patch is added to the func_stack list,
> > the old patch is already set to nop.
>       ^^^
>
>      The nops are set in the _new_ patch for functions which will
>      not longer get livepatched, see the commit e1452b607c48c642
>      ("livepatch: Add atomic replace") for more details.
>
> > If klp_ftrace_handler() is
> > triggered at this point, it will effectively do nothing=E2=80=94in othe=
r
> > words, it will execute the original function.
> > I might be wrong.
>
> Fortunately, you are wrong. This would be a serious violation of
> the consistency model and livepatches modifying some semantic would
> blow up systems.

That is great. Thanks for your help.

--=20
Regards
Yafang

