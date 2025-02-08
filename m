Return-Path: <live-patching+bounces-1140-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF803A2D705
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 16:47:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AADA83A7DC9
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 15:47:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 916CC2475F4;
	Sat,  8 Feb 2025 15:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C7RUtNAF"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB731ACEC2;
	Sat,  8 Feb 2025 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739029646; cv=none; b=hzkKhzJhaFZ1WQ+P+Uzza1bSqmogBqVgX7IZKU/EL/p0IBySRjEM7C1UawfQ46yljTeVKrQIO7JurWYRHX2yeh2aK5tbUMqQfgi2bkbsi7dxqxhZlHG34Jou+zLr5RhgRPiu7s2/egMTJU5suz/v7SsaXqDEjV7wgQx8zhqa2j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739029646; c=relaxed/simple;
	bh=q+MDvtLlIi69K27ReX3lDDeT3LJLFUyE4Y1+7Huku2o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A3vPS6/sSl/UpJJQlEdsq2fKqpNcwdntG4vmuBDIEmFbkfJhL0UvnORgxgo7hcm/V0w8QllRumQK+0dGA21p68SGY5VfVrwBjYhUo4gmmeeVXRGs6QrJIzopR/foseQs8XLfEhPZZoomBEZivMdazOf8yRPHOjRu0nIAwDItFhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C7RUtNAF; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4362f61757fso29297355e9.2;
        Sat, 08 Feb 2025 07:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739029643; x=1739634443; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Ucm5nxe8cgExY3vq78pW2gU4Ws9xivfjS2fHeRhYTY=;
        b=C7RUtNAF2QE3MngF0Ifhi9i9YnNw5keGDk0rF+wdb++ZIxVB0L/j3jSGahYbMUv6S9
         MbKoNEi3u7W2VHOTlgm7EN5SeSa3ghAaJwAuv9uMtqmk36s6xygRi1funrIZsz79FY3j
         I1sgDESFeCNEMs/M09vVusLUykilZubNxnJOt+XAGBQV1LGvYzMRp9cYDwHgGiScdAT2
         x2o/VLxZmS8LRuKQ4vRgGVVNWgDnaalyvFmxO7ExSN6jt+BLiJ8oT8TupRHC7hkHopVn
         w0+VK2cKjdQnxtnIjk9Bs3hHFGL7k+0ZDJHgzY2byYGQ6/Hj4v7MGlo7x+P31FwO8IY/
         kaGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739029643; x=1739634443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Ucm5nxe8cgExY3vq78pW2gU4Ws9xivfjS2fHeRhYTY=;
        b=MGvZRlYPgLeLAbP0WXKmYqIsCjy/DOePz/3azZBXA6RQnWThfnYG7IucgogfqkbgSc
         XyJkFudORRp+lRW1TuDjlNeSGwVStioJfh/Z5fCKfhJkwsQDG01QAKKZG4E+6B0nuE10
         eRkMzEODOpmKK6OWpX65xxtl2w1Ws3dp9TAna+UQaKFX1eSpceOwXk/cAJNcLvw/rCbA
         WEgks1RqTuKFg7eWOE0GHo0ur1b26fLsa2sIzXo2+FyDbsbM4kLT/SUIeNRpb2LeIF3l
         aI0SJU4riDV0bl+d5VnicoLQPD8YvT60otdS5LXKnz8jbqo7xYdLIbvvEps37c6vyOAV
         Wwrg==
X-Forwarded-Encrypted: i=1; AJvYcCUZMNqFy8uuDtNTBHEMuwKUpM908gkeif3Dkn7VjpNxRxdjyr6FEi8cpIi0/soHcgONJeoVmejyGmvCh0YkAw==@vger.kernel.org, AJvYcCVnPggbLtR2UhxJbmeORsFaxVwSktfPSUD+SWIvbOjcRbf4VqACI3tL5LgkFZUWV1/GlS5YtqaITobkEaUX@vger.kernel.org, AJvYcCWgKCrUpP+s8IhtATWBAq5/zOSPXxRYQKx73aOaOeN03L0T2QGmqGGFjUI5KEYdLss/874=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjemRxTIy9qUnyvsv5b4XOruhUoz5RMoYOQNnjIcVbwLiX97ny
	1cGC8GcwAZZFbJoj+shIOf0hV7QuovROYx6m9FR3r5BQik32IQ3o5GyCoY9qkAdVlUKW9AsyLGu
	1doA79psUayKKPNrNdkm1C+yxmhw=
X-Gm-Gg: ASbGncsZmkr8xlh0NFQRtvrEyxOqzDxu5qLCpsFQlJNRhu5sTVcsS+jM88ktyqb8eKj
	5uOgi2Qij3ogV4SQgfZhcLnUhwUtZIh04a8HL8X8HQrpBQGJN6PsKRWfpOwc5ETpKWlu252mzt0
	rL7bUoYIeiOhUb6XEX50f1h7v+bCx3
X-Google-Smtp-Source: AGHT+IHhaqyd4g185PU4eVAqjVQtrJsSiS+LXstK8Loa3UCPWLCPxC+cz3OYe2OCF/ugN6bwdBMmPNV9TnSir4OMJvg=
X-Received: by 2002:a05:600c:3b8e:b0:42c:b9c8:2bb0 with SMTP id
 5b1f17b1804b1-4392497c946mr53277355e9.4.1739029642917; Sat, 08 Feb 2025
 07:47:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250127063526.76687-1-laoar.shao@gmail.com> <Z5eOIQ4tDJr8N4UR@pathway.suse.cz>
 <CALOAHbBZc6ORGzXwBRwe+rD2=YGf1jub5TEr989_GpK54P2o1A@mail.gmail.com>
 <alpine.LSU.2.21.2501311414281.10231@pobox.suse.cz> <CALOAHbDwsZqo9inSLNV1FQV3NYx2=eztd556rCZqbRvEu+DDFQ@mail.gmail.com>
 <CAPhsuW4gYKHsmtHsBDUkx7a=apr_tSP_4aFWmmFNfqOJ+3GDGQ@mail.gmail.com>
 <CALOAHbDYFAntFbwMwGgnXkHh1audSoUwG1wFu_4e8P=c=hwZ0w@mail.gmail.com>
 <CAPhsuW4HsTab+w2r23bM52kcM1RBFBKP5ujVdDvxLE9OiqgMdA@mail.gmail.com>
 <CALOAHbAJBwSYju3-XEQwy0O1DNPawuEgmhrV5ECTrL9J388yDw@mail.gmail.com>
 <CAPhsuW51E4epDCrdNcQCG+SzHiyGhE+AocjmXoD-G0JExs9N1A@mail.gmail.com> <CALOAHbAaCbvr=F6PBJ+gnQa1WNidELzZW-P2_HmBsZ1tJd6FFg@mail.gmail.com>
In-Reply-To: <CALOAHbAaCbvr=F6PBJ+gnQa1WNidELzZW-P2_HmBsZ1tJd6FFg@mail.gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Sat, 8 Feb 2025 07:47:12 -0800
X-Gm-Features: AWEUYZlDgwJ7w9RtugurSHUaVGNWz4hZIXfuHiwIgOVVJOukfqJCOGpHVpr1kvs
Message-ID: <CAADnVQJZCE-Rh4xghLrruY8DW00cRUq9-ct6d=qfKk8Yc+8=pQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] livepatch: Add support for hybrid mode
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 10:42=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> On Fri, Feb 7, 2025 at 2:01=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > On Wed, Feb 5, 2025 at 6:55=E2=80=AFPM Yafang Shao <laoar.shao@gmail.co=
m> wrote:
> > [...]
> > > > I think we should first understand why the trampoline is not
> > > > freed.
> > >
> > > IIUC, the fexit works as follows,
> > >
> > >   bpf_trampoline
> > >     + __bpf_tramp_enter
> > >        + percpu_ref_get(&tr->pcref);
> > >
> > >     + call do_exit()
> > >
> > >     + __bpf_tramp_exit
> > >        + percpu_ref_put(&tr->pcref);
> > >
> > > Since do_exit() never returns, the refcnt of the trampoline image is
> > > never decremented, preventing it from being freed.
> >
> > Thanks for the explanation. In this case, I think it makes sense to
> > disallow attaching fexit programs on __noreturn functions. I am not
> > sure what is the best solution for it though.
>
> There is a tools/objtool/noreturns.h. Perhaps we could create a
> similar noreturns.h under kernel/bpf and add all relevant functions to
> the fexit deny list.

Pls avoid copy paste if possible.
Something like:

BTF_SET_START(fexit_deny)
#define NORETURN(fn) BTF_ID(func, fn)
#include "../../tools/objtool/noreturns.h"

Should work?

Josh,
maybe we should move noreturns.h to some common location?

