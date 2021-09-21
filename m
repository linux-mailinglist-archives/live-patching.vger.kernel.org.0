Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB43413A25
	for <lists+live-patching@lfdr.de>; Tue, 21 Sep 2021 20:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhIUSmY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Sep 2021 14:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbhIUSmW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Sep 2021 14:42:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B89C061574;
        Tue, 21 Sep 2021 11:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VCDewzfHbbVh3g/pRbOQUFxbt5WA/PRKwiZLKfGDQGo=; b=BN8N5u5qh8Fz/U0975RdYo6u27
        Cw+dJJlx9MbHYoL8blt8kjhIP9YlJW3Z07zt2ASJc6CKxpub8T6ZfsKGGtYK4F7xt7zcRAojyBKbr
        /T5JcwQYAYanMTWU3d+V6lrLSWdl0lXAPNyhl1XOwOkJWnnobkZ+ZBxEJuyELDHz2PNYpQaYuMg03
        OIcOODNHbkS59B7cp2LcuIUiVlvH20/YZTXEI8Co39N4Z0BjNPfK9URWHk2ZbHJ19ACerCu65//XF
        tORQkZU1xyGDdjgBNOlf8CyAJtadq8RHf+Qi2hKdCu+/M/7GyVTvm2QNeQgHKajEe+NUugwFVrobi
        mvOP0VsQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mSkhI-005W8J-I5; Tue, 21 Sep 2021 18:40:52 +0000
Date:   Tue, 21 Sep 2021 11:40:52 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-modules <linux-modules@vger.kernel.org>,
        live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        Jessica Yu <jeyu@kernel.org>, osandov@fb.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] libkmod: add a library notice log level print
Message-ID: <YUonNDxy+8zU9B52@bombadil.infradead.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-2-mcgrof@kernel.org>
 <CAKi4VAKa7LKXdRmA7epgbkUZw2wpUz19JYYdZ35mPCxSL_W_kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAKa7LKXdRmA7epgbkUZw2wpUz19JYYdZ35mPCxSL_W_kw@mail.gmail.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Sep 20, 2021 at 10:53:53PM -0700, Lucas De Marchi wrote:
> On Mon, Aug 9, 2021 at 11:56 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > When you use pass the -v argument to modprobe we bump
> > the log level from the default modprobe log level of
> > LOG_WARNING (4) to LOG_NOTICE (5), however the library
> > only has avaiable to print:
> >
> >  #define DBG(ctx, arg...) kmod_log_cond(ctx, LOG_DEBUG, ## arg)
> >  #define INFO(ctx, arg...) kmod_log_cond(ctx, LOG_INFO, ## arg)
> >  #define ERR(ctx, arg...) kmod_log_cond(ctx, LOG_ERR, ## arg)
> >
> > LOG_INFO (6) however is too high of a level for it to be
> > effective at printing anything when modprobe -v is passed.
> > And so the only way in which modprobe -v can trigger the
> > library to print a verbose message is to use ERR() but that
> > always prints something and we don't want that in some
> > situations.
> >
> > We need to add a new log level macro which uses LOG_NOTICE (5)
> > for a "normal but significant condition" which users and developers
> > can use to look underneath the hood to confirm if a situation is
> > happening.
> >
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  libkmod/libkmod-internal.h | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/libkmod/libkmod-internal.h b/libkmod/libkmod-internal.h
> > index 398af9c..2e5e1bc 100644
> > --- a/libkmod/libkmod-internal.h
> > +++ b/libkmod/libkmod-internal.h
> > @@ -25,10 +25,12 @@ static _always_inline_ _printf_format_(2, 3) void
> >  #  else
> >  #    define DBG(ctx, arg...) kmod_log_null(ctx, ## arg)
> >  #  endif
> > +#  define NOTICE(ctx, arg...) kmod_log_cond(ctx, LOG_NOTICE, ## arg)
> >  #  define INFO(ctx, arg...) kmod_log_cond(ctx, LOG_INFO, ## arg)
> >  #  define ERR(ctx, arg...) kmod_log_cond(ctx, LOG_ERR, ## arg)
> >  #else
> >  #  define DBG(ctx, arg...) kmod_log_null(ctx, ## arg)
> > +#  define NOTICE(ctx, arg...) kmod_log_cond(ctx, LOG_NOTICE, ## arg)
> 
> did you mean kmod_log_null()?

Sure, feel free to change on your end or let me know if you would
prefer if I respin.

  Luis
