Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62D04159B8
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 10:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbhIWID6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 04:03:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:11295 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239732AbhIWIDu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 04:03:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="203945187"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="203945187"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 01:02:16 -0700
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="435729635"
Received: from eugenias-mobl.amr.corp.intel.com (HELO ldmartin-desk2) ([10.252.133.66])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 01:02:13 -0700
Date:   Thu, 23 Sep 2021 01:02:13 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Lucas De Marchi <lucas.de.marchi@gmail.com>,
        linux-modules <linux-modules@vger.kernel.org>,
        live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        Jessica Yu <jeyu@kernel.org>, osandov@fb.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] libkmod: add a library notice log level print
Message-ID: <20210923080213.s3zoqcvngvk2h3f7@ldmartin-desk2>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-2-mcgrof@kernel.org>
 <CAKi4VAKa7LKXdRmA7epgbkUZw2wpUz19JYYdZ35mPCxSL_W_kw@mail.gmail.com>
 <YUonNDxy+8zU9B52@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YUonNDxy+8zU9B52@bombadil.infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Sep 21, 2021 at 11:40:52AM -0700, Luis Chamberlain wrote:
>On Mon, Sep 20, 2021 at 10:53:53PM -0700, Lucas De Marchi wrote:
>> On Mon, Aug 9, 2021 at 11:56 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>> >
>> > When you use pass the -v argument to modprobe we bump
>> > the log level from the default modprobe log level of
>> > LOG_WARNING (4) to LOG_NOTICE (5), however the library
>> > only has avaiable to print:
>> >
>> >  #define DBG(ctx, arg...) kmod_log_cond(ctx, LOG_DEBUG, ## arg)
>> >  #define INFO(ctx, arg...) kmod_log_cond(ctx, LOG_INFO, ## arg)
>> >  #define ERR(ctx, arg...) kmod_log_cond(ctx, LOG_ERR, ## arg)
>> >
>> > LOG_INFO (6) however is too high of a level for it to be
>> > effective at printing anything when modprobe -v is passed.
>> > And so the only way in which modprobe -v can trigger the
>> > library to print a verbose message is to use ERR() but that
>> > always prints something and we don't want that in some
>> > situations.
>> >
>> > We need to add a new log level macro which uses LOG_NOTICE (5)
>> > for a "normal but significant condition" which users and developers
>> > can use to look underneath the hood to confirm if a situation is
>> > happening.
>> >
>> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>> > ---
>> >  libkmod/libkmod-internal.h | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/libkmod/libkmod-internal.h b/libkmod/libkmod-internal.h
>> > index 398af9c..2e5e1bc 100644
>> > --- a/libkmod/libkmod-internal.h
>> > +++ b/libkmod/libkmod-internal.h
>> > @@ -25,10 +25,12 @@ static _always_inline_ _printf_format_(2, 3) void
>> >  #  else
>> >  #    define DBG(ctx, arg...) kmod_log_null(ctx, ## arg)
>> >  #  endif
>> > +#  define NOTICE(ctx, arg...) kmod_log_cond(ctx, LOG_NOTICE, ## arg)
>> >  #  define INFO(ctx, arg...) kmod_log_cond(ctx, LOG_INFO, ## arg)
>> >  #  define ERR(ctx, arg...) kmod_log_cond(ctx, LOG_ERR, ## arg)
>> >  #else
>> >  #  define DBG(ctx, arg...) kmod_log_null(ctx, ## arg)
>> > +#  define NOTICE(ctx, arg...) kmod_log_cond(ctx, LOG_NOTICE, ## arg)
>>
>> did you mean kmod_log_null()?
>
>Sure, feel free to change on your end or let me know if you would
>prefer if I respin.

fixed that and pushed this patch.

thanks
Lucas De Marchi

>
>  Luis
