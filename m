Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F81F900CF
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2019 13:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfHPLgL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Aug 2019 07:36:11 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:17417 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727021AbfHPLgL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Aug 2019 07:36:11 -0400
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id x7GBZrpM022199;
        Fri, 16 Aug 2019 20:35:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com x7GBZrpM022199
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1565955354;
        bh=ZGRmRX21HFZjQOo6RUWLj0+rE8mt19pv78l71bEdnLE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VA46zsniLssyX0pAMX25lscd0r1N4AERHsHGfn/BoCbWRt5Od0fH84SzCDb+4bgj9
         4PtYMEX8lwJaVhk5GAfHXSYtAvJirrFQ6PwcIsmj14zJS6jA8BAuc5fPIUy0JQkI5M
         m3muZLwX4Brc++HuqYi6HQ3e3S4SUhVtV7mkzQOUtLA5tfcrDo4OQGVHchImcr5eZL
         SMASoPj+iBbsXXnnmkDwuQXhH0VGJJWexuX1+qsLK82GZY9NzYo++5K0aJFPx5ENZg
         PUJlNqXjDP60SrILfi0Sy2YMGN7F2S+LpQl2yjZP2ZqJnPKktQO3mT5w96U1LlCXKc
         hY+kgNIRUJ6sg==
X-Nifty-SrcIP: [209.85.217.46]
Received: by mail-vs1-f46.google.com with SMTP id y16so3512031vsc.3;
        Fri, 16 Aug 2019 04:35:53 -0700 (PDT)
X-Gm-Message-State: APjAAAUNttRxHmDAoK2BA8b6y/xsOtcVl6kGq33FntpE9n9DRNn6wOTK
        hyLbDFw+xX5OrO5xqgz+JgIRLxfRLdiwYHfe4t8=
X-Google-Smtp-Source: APXvYqzv23a3GBmJ0SccB/pHPvVNysuT6fBRyLXfZ2q4xrQiSNthqFdA1frMSstRmg8ojb3PZyJahfOTRwUbs+uozOM=
X-Received: by 2002:a67:fe12:: with SMTP id l18mr5914342vsr.54.1565955352684;
 Fri, 16 Aug 2019 04:35:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <20190509143859.9050-8-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-8-joe.lawrence@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Fri, 16 Aug 2019 20:35:16 +0900
X-Gmail-Original-Message-ID: <CAK7LNARmkRi1ug9C780egxUn1m1FMxAE+uN1d08hLNYZF1724Q@mail.gmail.com>
Message-ID: <CAK7LNARmkRi1ug9C780egxUn1m1FMxAE+uN1d08hLNYZF1724Q@mail.gmail.com>
Subject: Re: [PATCH v4 07/10] livepatch: Add sample livepatch module
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Joe,

On Thu, May 9, 2019 at 11:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> From: Josh Poimboeuf <jpoimboe@redhat.com>
>
> Add a new livepatch sample in samples/livepatch/ to make use of
> symbols that must be post-processed to enable load-time relocation
> resolution. As the new sample is to be used as an example, it is
> annotated with KLP_MODULE_RELOC and with KLP_SYMPOS macros.
>
> The livepatch sample updates the function cmdline_proc_show to
> print the string referenced by the symbol saved_command_line
> appended by the string "livepatch=1".
>
> Update livepatch-sample.c to remove livepatch MODULE_INFO
> statement.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Joao Moreira <jmoreira@suse.de>
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---


> --- /dev/null
> +++ b/samples/livepatch/livepatch-annotated-sample.c
> @@ -0,0 +1,102 @@
> +/*
> + * livepatch-annotated-sample.c - Kernel Live Patching Sample Module
> + *
> + * Copyright (C) 2014 Seth Jennings <sjenning@redhat.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.

Please use SPDX instead of the license boilerplate.

Thanks.


-- 
Best Regards
Masahiro Yamada
