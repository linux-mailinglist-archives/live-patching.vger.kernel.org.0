Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5DC3F9EDA
	for <lists+live-patching@lfdr.de>; Fri, 27 Aug 2021 20:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhH0SeR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Aug 2021 14:34:17 -0400
Received: from mail-yb1-f171.google.com ([209.85.219.171]:43994 "EHLO
        mail-yb1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhH0SeN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Aug 2021 14:34:13 -0400
Received: by mail-yb1-f171.google.com with SMTP id k78so11000759ybf.10
        for <live-patching@vger.kernel.org>; Fri, 27 Aug 2021 11:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Odf83BsyFbSOp9xrUYgqq4I8qvyvjd7KcyZ1hxTQiRA=;
        b=KYSjEfPA0vFih+yX8QXaDtGwX4LpWT5b0NH3DJaZlYxV9uwI6xABqY0PPDe3fQumo8
         oNE0JxZWTPSF8pS+gILgm+Ux+A+rJkTdMM1qKy8hVkvthz9DFKEH+F9Yd1auEd9dca3J
         m6J7AJI0N87I71tX9sj9Tbl1TyGjU7J4NW9yXjRl44BBt8NnoORSHIg5Gk1CD6eVin9Z
         rcwdx2sHW+V6Lb3zH0bHKiDV+4ffP5AbuzHYDWFXzjfCNwQEjzL4a77NpcABXMuuqZqW
         ZhSruuWFowhr0mY6VmXWprkBJDLEblX2xKYReK7GOeWTHcjQZByr25Nhd15toIxEv54d
         qSEQ==
X-Gm-Message-State: AOAM530y2lQ1um4XUx0dh8NToT0JIbUpRaBZDEgZYSWEpgI4PHCocHYX
        JANetdjQCZGrRWPD/0muJBwQ4VHJQIyT5w0tpFk=
X-Google-Smtp-Source: ABdhPJy0+HrUwYElYfuyrezKsPHcePYFg2uiSrISUe5qFsbwsWCgU+CZyZA4SdU34dfUhPtyhj6ZO4WhwRYLLf3WfR0=
X-Received: by 2002:a25:84ce:: with SMTP id x14mr6668170ybm.511.1630089203158;
 Fri, 27 Aug 2021 11:33:23 -0700 (PDT)
MIME-Version: 1.0
References: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
 <01b7d9fa-d3be-ec36-0863-fd175b62c2b9@virtuozzo.com>
In-Reply-To: <01b7d9fa-d3be-ec36-0863-fd175b62c2b9@virtuozzo.com>
From:   Peter Swain <swine@pobox.com>
Date:   Fri, 27 Aug 2021 11:33:12 -0700
Message-ID: <CABFpvm1D41RJfYsk4M6SCfogUUZnvuiZ0Xs+CQkr6Zjb1J7u5Q@mail.gmail.com>
Subject: Re: announcing LLpatch: arch-independent live-patch creation
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc:     live-patching@vger.kernel.org, madvenka@linux.microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

(apologies for re-post, having trouble enforcing no-HTML mode in gmail)

On Fri, Aug 27, 2021 at 9:08 AM Evgenii Shatokhin <eshatokhin@virtuozzo.com>
wrote:
> LLpatch requires a pre-built kernel tree ("repository"), right?
Yes.
It doesn't rebuild existing *.o as a pre-image of the patched code, as
kpatch does.
But LLpatch does use the dependency analysis the previous make left in
*.o.cmd, although the same information could also be extracted by "make -n
-W changed_file ..."

> Does that mean that the kernel should be built with clang first?
> Or, perhaps, clang is only used when building the patch itself, while
> the kernel can be built with GCC or other compiler used by the given
> Linux distro?
We haven't explored this deeply, as all our kernels are clang-built.
In principle this should work with gcc-built kernels, as long as the
particular change doesn't intersect with some feature which is expressed
differently between the gcc/clang worlds, such as some ELF section names.
But as there are so many such potential incompatibilities, we do not
recommend this.
As a precondition for LLpatch-patchable kernels, I would recommend moving
to clang-built base kernels
