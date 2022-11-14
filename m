Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A1362813B
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 14:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236197AbiKNN0Z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 08:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbiKNN0Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 08:26:24 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D690183B6;
        Mon, 14 Nov 2022 05:26:23 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id v17so17273774edc.8;
        Mon, 14 Nov 2022 05:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AjEtgGGwNMbPprD3H7P+1amTVuS4bSxngS1okyU2BrQ=;
        b=JVpBwR/tgyW0nfSDZeOYStbM7P6ueoMgnbP96FdN+FP/v4XA+J/K1oVMRqGeZl55PN
         egMcxElq18V/AantX0ASEZe+GY0JtRHJGUwMetqM9XsLyIJqx4kCQGmfdtK4GuUjqni9
         f6rE+0yL24ESEASBJEVpbsYNhC4te0jAyiH+LOU119v8WlfvzllCtahNFTvrchWAFLyv
         Rf66x69TrKQcPOBY6onBz7v3KNiUdubea6wDxX/+46TCLPe38g3AqpGyC0WEHuCkAv/O
         cutFgnCYAXPyJQkPixELElguvE8tbFqaKgaqECNZ5+ETkT4aEEcKECPZXo5monjFf5wE
         V6Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjEtgGGwNMbPprD3H7P+1amTVuS4bSxngS1okyU2BrQ=;
        b=Z+3F0/pYVUncqQO0QVSwx62AdE1Zbv5KOKOMF4ygpC4guYQL6kvfuKuXTo9C/8MlFQ
         yvi2HpkUZUDxy5TGzltZyob/aT6/2ctweunbra8Sv2MRyvi6p8lz+a68IhhKYH011SxY
         Mymeq7YrT1TR+Xrn7J5RPnNh1Cz+XGeIQyZI9iMvuFPWXp+itlXO3iaHcEEOMmapLXYj
         jOEO8iWVXMf2ovIgW7D6ENyInof4EARXmCORb0mdTJ9fzBJKk3KOjBRLPOHZj04zaOWw
         kiJAxwU/WdBXD6+4C6LjWQW1bLuJYbWU9dJo5BSU898dgOTmX33kqNImPgoSaQzvGl2x
         quoA==
X-Gm-Message-State: ANoB5pmyFYjNXDGxS800fIK9DlAnsgpD448NxZmaprW5IgrPQed49b45
        C+9yycs2m/Lcm/wndT6S1whkNtZ6jHHoUg==
X-Google-Smtp-Source: AA0mqf6IPlcVUMBFbPlmxPvEGJH+/EHq8udoRbxRttEMufGeS2dm/xvdO1iGjsKkHFidd3gv7CKIMQ==
X-Received: by 2002:aa7:de88:0:b0:458:b42e:46e6 with SMTP id j8-20020aa7de88000000b00458b42e46e6mr11250927edv.375.1668432381832;
        Mon, 14 Nov 2022 05:26:21 -0800 (PST)
Received: from krava ([83.240.62.198])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b007aa3822f4d2sm4305324ejg.17.2022.11.14.05.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 05:26:21 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 14 Nov 2022 14:26:19 +0100
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Jiri Olsa <olsajiri@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v8 7/9] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <Y3JB++KOXxMWWX35@krava>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-8-thunder.leizhen@huawei.com>
 <Y3HyrIwlZPYM8zYd@krava>
 <050b7513-4a20-75c7-0574-185004770329@huawei.com>
 <Y3IJ5GjrXBYDbfnA@krava>
 <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
 <Y3IY6gzDtk1ze3u7@krava>
 <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 14, 2022 at 07:30:16PM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/11/14 18:31, Jiri Olsa wrote:
> > On Mon, Nov 14, 2022 at 06:00:38PM +0800, Leizhen (ThunderTown) wrote:
> >>
> >>
> >> On 2022/11/14 17:27, Jiri Olsa wrote:
> >>> On Mon, Nov 14, 2022 at 04:50:25PM +0800, Leizhen (ThunderTown) wrote:
> >>>>
> >>>> On 2022/11/14 15:47, Jiri Olsa wrote:
> >>>>> On Wed, Nov 02, 2022 at 04:49:19PM +0800, Zhen Lei wrote:
> >>>>>> Currently we traverse all symbols of all modules to find the specified
> >>>>>> function for the specified module. But in reality, we just need to find
> >>>>>> the given module and then traverse all the symbols in it.
> >>>>> hi,
> >>>>> sorry for delayed answer, I did not notice this until Stephen's email
> >>>>> about merge issue with recent bpf change [1]
> >>>>>
> >>>>>> Let's add a new parameter 'const char *modname' to function
> >>>>>> module_kallsyms_on_each_symbol(), then we can compare the module names
> >>>>> we have use case for iterating all modules and their symbols when we
> >>>>> want to resolve passed addresses for tracing
> >>>>>
> >>>>> we don't have 'modname' that we could pass, we need to iterate all modules
> >>>>>
> >>>>> so perhaps this could be made optional like with passing NULL for modname?
> >>>> The deletion of modname was suggested by Petr Mladek. The reason is that
> >>>> everyone passes modname as NULL, there was no actual demand at the time.
> >>>> https://lkml.org/lkml/2022/9/20/682
> >>>>
> >>>>>> directly in this function and call hook 'fn' after matching. And the
> >>>>>> parameter 'struct module *' in the hook 'fn' can also be deleted.
> >>>>> we need 'struct module *' argument in the callback as well because we are
> >>>>> taking the module reference if we trace function in it, so it wont get
> >>>>> unloaded
> >>>>>
> >>>>> please let me know if I should do the change or can help in any way
> >>>> It seems that we should take the module reference before invoking callback
> >>>> and put it after it is called, without passing modname.
> >>> we take the module ref only if we (callback) find the traced address in
> >>> the module, we don't have the module object before
> >>>
> >>> jirka
> >>>
> >>
> >> Do it in function module_kallsyms_on_each_symbol()?
> >>
> >> But I just saw that mutex_lock(&module_mutex) protection is already
> >> provided in this function. So reference counting protection may not
> >> be required.
> > 
> > we take the module ref so it won't unload even outside of the
> > module_kallsyms_on_each_symbol function
> 
> There's another way to do it, but it's more time consuming.
> 
> struct module *__module_text_address(unsigned long addr);
> struct module *__module_address(unsigned long addr);
> 
> Which way do you think is more appropriate?

I think it'd be best to keep the module argument in the callback,
I don't see the harm.. AFAICS it was removed because you thought
nobody was using it, but that's not the case

using __module_text_address/__module_address might be doable and
it might be fast enough, because it's using rbtree

I'll check on that, meanwhile if we could keep the module argument,
that'd be great

thanks,
jirka
