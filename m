Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D42231566A
	for <lists+live-patching@lfdr.de>; Tue,  9 Feb 2021 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhBIS6f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 Feb 2021 13:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbhBISv6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 Feb 2021 13:51:58 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0629C0617AB
        for <live-patching@vger.kernel.org>; Tue,  9 Feb 2021 10:40:18 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id h26so3636912lfm.1
        for <live-patching@vger.kernel.org>; Tue, 09 Feb 2021 10:40:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yrqlWhEmS7qOnCD+PpBqDD/vJX8INiaqiRYekgJQZPQ=;
        b=Xv5BjgLYcmU0KX+yKZtjtFg1EszFEgfnsx23ypgGzZdhfjQ2uhx0rMeCFUeL5XrtRL
         YO09vC7QZcYwTcu/8akG7OpWlzFlemPQkHkOCvwrfIRlH4mPHf1PL9T0mqlq5zyi1BdM
         8b2RY8cyGJDx1EnZISySmVhjkPFLhbEhEex5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yrqlWhEmS7qOnCD+PpBqDD/vJX8INiaqiRYekgJQZPQ=;
        b=jZMqVw+JCZ5e49P0XmVowT387XZuT003zRG+MHeViWb3bW60qS1FzFEe0cxRz/I/BP
         kWhUf1cz6ykbl0zRbhoqUO4kuGR3epbehgv8A355LcxKK4ShEJTR7sMC6sqTXefCtSjO
         R+l0tgawEgr5f2BQzgI/ujnKvL/l5KV+vZsULL8iz3V2UENRdFHIM8M5tKfAwzbuXdCi
         Mt+UjzsLC1rE2mQM+2k37TC3EuJBv1tCHZCKYiWCmJaqW3cYTfR1Bb+bUfS+9Pvps4DZ
         OruSptbQY+XF29zbJINEw96gVxjgzZNT6B4tszs1CFfYaZcrOtd6i4pD+xoWE/4o7OOo
         E+HQ==
X-Gm-Message-State: AOAM532oY5Bn7yZALrIYtToT+RUNQDL7aNmT6P1znd1TaEhe2x553+AQ
        jPmJHCKKtLVF5pi2Uf6TU3UYF4n/7M0KAw==
X-Google-Smtp-Source: ABdhPJyY+4oJsy+0QJCvJJe9tyKwVl2hUe7cfP3EhPKBFUHxc1j8R/Si7JCkAsDx02fFpdn2k8BTpw==
X-Received: by 2002:a05:6512:39c3:: with SMTP id k3mr13753796lfu.501.1612896016808;
        Tue, 09 Feb 2021 10:40:16 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id j23sm2696988lfh.190.2021.02.09.10.40.15
        for <live-patching@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 10:40:15 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id u4so23724843ljh.6
        for <live-patching@vger.kernel.org>; Tue, 09 Feb 2021 10:40:15 -0800 (PST)
X-Received: by 2002:a2e:b70b:: with SMTP id j11mr14786681ljo.61.1612896014711;
 Tue, 09 Feb 2021 10:40:14 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgNXnmxjm+kK1ufjHfQPOBbuD5w3CTkSe0azF3NNWEHHQ@mail.gmail.com>
 <3C17D187-8691-4521-9B64-F42A0B514F13@amacapital.net>
In-Reply-To: <3C17D187-8691-4521-9B64-F42A0B514F13@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 10:39:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg5132yO6AV=uQkNO=aGukfzE8Ji6AFuSxpdNto4ukAbw@mail.gmail.com>
Message-ID: <CAHk-=wg5132yO6AV=uQkNO=aGukfzE8Ji6AFuSxpdNto4ukAbw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/urgent for v5.11-rc7
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@intel.com>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 9, 2021 at 10:26 AM Andy Lutomirski <luto@amacapital.net> wrote=
:
> >
> > Anything else would just be insanely complicated, I feel.
>
> The other model is =E2=80=9Cdon=E2=80=99t do that then.=E2=80=9D

Hmm. I guess all the code that does int3 patching could just be taught
to always go to the next instruction instead.

I don't think advancing the rewriting is an option for the asm
alternative() logic or the static call infrastructure, but those
should never be about endbr anyway, so presumably that's not an issue.

So if it ends up being _only_ about kprobes, then the "don't do that
then" might work fine.

                 Linus
