Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906C4627A84
	for <lists+live-patching@lfdr.de>; Mon, 14 Nov 2022 11:31:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236228AbiKNKbo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Nov 2022 05:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236269AbiKNKbL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Nov 2022 05:31:11 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B325E13CEB;
        Mon, 14 Nov 2022 02:31:10 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o30so7146044wms.2;
        Mon, 14 Nov 2022 02:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TtcLNi7tC7VoXUW8XmXn99oLkoAAo0InkjTMRf4bmeE=;
        b=cnkmuHD7oFyxoE3BFuMTChrbYeCfQtstPgtM5B1oWK1SXWUj8xVQ9s86ljm4VGdq0e
         2gmJPnqZBi9Q0XqWd6MzA0pGOO/JGtzqTsaexGkMH2ghLTkSzI3X0dmnmP0fc2ip2XIC
         c5GH1dKY40VqlM2m+JNsGawSOzZ9HItXFJgfe1/apiIOtXBUk+P3dtaWF7AmthDs+qkJ
         tQeOQ+JvAMRV037sL61QwRWHXp+bHm8sOiBIHy6sv4pDsK4zsP10GWBro6fLWenbVfKq
         sMBGt96H/dyPqJ0x1pyaXiwJpq91eD/Fljp+4djd6fEq3qv1ZZrqfHCaBVgGdWNvmLDP
         YdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtcLNi7tC7VoXUW8XmXn99oLkoAAo0InkjTMRf4bmeE=;
        b=6pQD0HxBzgSsDnS/SSSP/3ACSITghwCJQBh8U8iZIadwunKag4mZhwjL6lrpFK1h1d
         QxUHC4ixY+IZXRYsnG7nDt2OUQw5KRqCbOjKWEFLX3t6Kje8la9YCtdGl8/l9Z6Ow0o8
         N3WiHGbMGbvuD7wM7qB8CDH0JGOPxvIihYlxPHlhANqypbAo1XqcpSayRlcom3mk22AB
         YgkGEdIyJX6phQ9Kr3AgNMexe2y2pufclqalDkvtORZejC4zS9OoHdt+og9x8O66Lm/n
         q7v6RZI5JtWtD2YKkP5jZHkL2rqLUdGNNooxe1qLBP3C5L3iOF/SIt33398l0Apagf3Q
         AvZg==
X-Gm-Message-State: ANoB5pmHMeUVaYHVAeKKLg6HSWc/TRNBQ0N0mKYgf/rujUOH2JM8DMLo
        YDH/+smE2B4eo8GWw2mf8zM=
X-Google-Smtp-Source: AA0mqf5IqJ4O9Zkfh9bfxL5vfiMLQCTv2xM9rFUSnwq2Yk0oOSaajLxS8EFlQ4TPS6NE8/7L+UWKaQ==
X-Received: by 2002:a05:600c:1c1a:b0:3cf:aae0:802a with SMTP id j26-20020a05600c1c1a00b003cfaae0802amr7467422wms.112.1668421869130;
        Mon, 14 Nov 2022 02:31:09 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d4884000000b002383e977920sm9105111wrq.110.2022.11.14.02.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 02:31:08 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 14 Nov 2022 11:31:06 +0100
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
Message-ID: <Y3IY6gzDtk1ze3u7@krava>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-8-thunder.leizhen@huawei.com>
 <Y3HyrIwlZPYM8zYd@krava>
 <050b7513-4a20-75c7-0574-185004770329@huawei.com>
 <Y3IJ5GjrXBYDbfnA@krava>
 <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Nov 14, 2022 at 06:00:38PM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/11/14 17:27, Jiri Olsa wrote:
> > On Mon, Nov 14, 2022 at 04:50:25PM +0800, Leizhen (ThunderTown) wrote:
> >>
> >> On 2022/11/14 15:47, Jiri Olsa wrote:
> >>> On Wed, Nov 02, 2022 at 04:49:19PM +0800, Zhen Lei wrote:
> >>>> Currently we traverse all symbols of all modules to find the specified
> >>>> function for the specified module. But in reality, we just need to find
> >>>> the given module and then traverse all the symbols in it.
> >>> hi,
> >>> sorry for delayed answer, I did not notice this until Stephen's email
> >>> about merge issue with recent bpf change [1]
> >>>
> >>>> Let's add a new parameter 'const char *modname' to function
> >>>> module_kallsyms_on_each_symbol(), then we can compare the module names
> >>> we have use case for iterating all modules and their symbols when we
> >>> want to resolve passed addresses for tracing
> >>>
> >>> we don't have 'modname' that we could pass, we need to iterate all modules
> >>>
> >>> so perhaps this could be made optional like with passing NULL for modname?
> >> The deletion of modname was suggested by Petr Mladek. The reason is that
> >> everyone passes modname as NULL, there was no actual demand at the time.
> >> https://lkml.org/lkml/2022/9/20/682
> >>
> >>>> directly in this function and call hook 'fn' after matching. And the
> >>>> parameter 'struct module *' in the hook 'fn' can also be deleted.
> >>> we need 'struct module *' argument in the callback as well because we are
> >>> taking the module reference if we trace function in it, so it wont get
> >>> unloaded
> >>>
> >>> please let me know if I should do the change or can help in any way
> >> It seems that we should take the module reference before invoking callback
> >> and put it after it is called, without passing modname.
> > we take the module ref only if we (callback) find the traced address in
> > the module, we don't have the module object before
> > 
> > jirka
> > 
> 
> Do it in function module_kallsyms_on_each_symbol()?
> 
> But I just saw that mutex_lock(&module_mutex) protection is already
> provided in this function. So reference counting protection may not
> be required.

we take the module ref so it won't unload even outside of the
module_kallsyms_on_each_symbol function

jirka
