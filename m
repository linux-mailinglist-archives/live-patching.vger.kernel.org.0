Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010416DC720
	for <lists+live-patching@lfdr.de>; Mon, 10 Apr 2023 15:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjDJNJ5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Apr 2023 09:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjDJNJ4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Apr 2023 09:09:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAE5D4ED2
        for <live-patching@vger.kernel.org>; Mon, 10 Apr 2023 06:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681132144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=motyMZYGjG8ZpzgKBhQCp3NlNr2re4z0Ma0gRtL0ojg=;
        b=Lu7ahFI0gWttfCuMZnt14th3Lstp+3qFad05XEe7CJsaMv7AZUeD2UbkbOtIeYHDGy4Ka4
        p2l6gyg9yRjG6xIRP7HM+1JUoqfp0yV4TUcc8D2qNlBTyTV8PBqO4c2dzBnDw00/6rKbUA
        7NbwOxkEybu79u6LKd2MjZ9Qtv0xEQc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-_-IcATl3MeChW7F5wrktPg-1; Mon, 10 Apr 2023 09:09:01 -0400
X-MC-Unique: _-IcATl3MeChW7F5wrktPg-1
Received: by mail-qt1-f200.google.com with SMTP id v13-20020a05622a144d00b003e22c6de617so4253798qtx.13
        for <live-patching@vger.kernel.org>; Mon, 10 Apr 2023 06:09:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681132141;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=motyMZYGjG8ZpzgKBhQCp3NlNr2re4z0Ma0gRtL0ojg=;
        b=1qF6xKjN1WqXESNPMQqZXmDuEKL0IIdC2fbdpIzYD9B9DbUeqGqLPRjPnC7TFEEc4Z
         /ZobpWyKV/nSe5SMMqbj5hbS3W67OVKE9IQ0773PuZrcaaECWsr/PlvHHgblTkdBycjD
         oBo8CSpKTsMXDugFMclj2pZTLP9RBG8nuuvLz8fARxEm5Dga25ewiTt72JJ5gp9HRC2S
         eCU2PW0S/RXOJG7JkOfPRUEpvcDNGD1ppfb9p/asSXWt2JPWjnX0ISyffzs7ztcLvYvJ
         sxGQbqKeX/OUvRIXnep26I7nM3Xjo3Pw5Yvi1yo0tIFGoerOQIeX95w8IrJjClr84mWy
         JsuQ==
X-Gm-Message-State: AAQBX9c1PMPhdPbh/xRoNFdquaZXuzCq1HYEJaPK2FGl5iovHc8C5r46
        UQbqFXUpKJhooapm2TATGpdvLemNnDzKHePah5gPs1vhl5LchRJYooaNfeATfbRQACamtrnpmmC
        +5mw3aZ4emyhbC1nXQb/tD+XkNw==
X-Received: by 2002:a05:622a:51:b0:3e6:9e18:73ee with SMTP id y17-20020a05622a005100b003e69e1873eemr8542961qtw.15.1681132141307;
        Mon, 10 Apr 2023 06:09:01 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZzjirNzSjNF5jT1Ah5Inm/x9IabKjpY5EYEIDyrRcBFwpvL0tmr37y9R10Y3VXQD6dUgFKPg==
X-Received: by 2002:a05:622a:51:b0:3e6:9e18:73ee with SMTP id y17-20020a05622a005100b003e69e1873eemr8542922qtw.15.1681132140968;
        Mon, 10 Apr 2023 06:09:00 -0700 (PDT)
Received: from [192.168.1.14] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id z63-20020a376542000000b007417e60f621sm3239007qkb.126.2023.04.10.06.08.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Apr 2023 06:09:00 -0700 (PDT)
Message-ID: <025f2151-ce7c-5630-9b90-98742c97ac65@redhat.com>
Date:   Mon, 10 Apr 2023 09:08:58 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Nick Alcock <nick.alcock@oracle.com>
Cc:     mcgrof@kernel.org, masahiroy@kernel.org,
        linux-modules@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?UTF-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>
References: <20221205163157.269335-1-nick.alcock@oracle.com>
 <20230407232118.o2x5lakfgyzy56gz@treble>
Content-Language: en-US
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH modules-next v10 00/13] kallsyms: reliable symbol->address
 lookup with /proc/kallmodsyms
In-Reply-To: <20230407232118.o2x5lakfgyzy56gz@treble>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 4/7/23 19:21, Josh Poimboeuf wrote:
> On Mon, Dec 05, 2022 at 04:31:44PM +0000, Nick Alcock wrote:
>> The whole point of symbols is that their names are unique: you can look up a
>> symbol and get back a unique address, and vice versa.  Alas, because
>> /proc/kallsyms (rightly) reports all symbols, even hidden ones, it does not
>> really satisfy this requirement.  Large numbers of symbols are duplicated
>> many times (just search for __list_del_entry!), and while usually these are
>> just out-of-lined things defined in header files and thus all have the same
>> implementation, it does make it needlessly hard to figure out which one is
>> which in stack dumps, when tracing, and such things.  Some configuration
>> options make things much worse: my test make allyesconfig runs introduced
>> thousands of text symbols named _sub_I_65535_1, one per compiler-generated
>> object file, and it was fairly easy to make them appear in ftrace output.
>>
>> Right now the kernel has no way at all to tell such symbols apart, and nor
>> has the user: their address differs and that's all.  Which module did they
>> come from?  Which object file?  We don't know.  Figuring out which is which
>> when tracing needs a combination of guesswork and luck, and if there are
>> thousands of them that's not a pleasant prospect.  In discussions at LPC it
>> became clear that this is not just annoying me but Steve Rostedt and others,
>> so it's probably desirable to fix this.
>>
>> It turns out that the linker, and the kernel build system, can be made to
>> give us everything we need to resolve this once and for all.  This series
>> provides a new /proc/kallmodsyms which is like /proc/kallsyms except that it
>> annotates every (textual) symbol which comes from a built-in kernel module
>> with the module's name, in square brackets: if a symbol is used by multiple
>> modules, it gets [multiple] [names]; if a symbol is still ambiguous it gets
>> a cut-down {object file name}; the combination of symbol, [module] [names]
>> and {object file name} is unique (with one minor exception: the arm64 nvhe
>> module is pre-linked with ld -r, causing all symbols in it to appear to come
>> from the same object file: if it was reworked to use thin archives this
>> problem would go away).
> 
> Hi Nick,
> 
> Sorry for jumping in late on an old patch set.  I just saw the LWN
> article about the MODULE_LICENSE() patches and I have some comments
> about duplicate symbols and a question about the motivation for this
> patch set.
> 
> For livepatch we have a solution for disambiguating duplicate local
> symbols called "sympos".  It works (for now) but there are some cases
> (like LTO) where it falls apart and it may not be the best long term
> solution.
> 
> The function granularity KASLR (fgkaslr) patches proposed a potentially
> better option: use the GNU linker -zunique_symbols flag which renames
> all duplicates to have unique names across the entire linked object.
> 

And IIRC, that idea was eventually dropped.  Fāng-ruì Sòng posted a few
reasons why -zunique-symbols wouldn't be a great solution [1]

[1]
https://lore.kernel.org/lkml/CAFP8O3K1mkiCGMTEeuSifZtr2piHsKTjP5TOA25nqpv2SrbzYQ@mail.gmail.com/

<file + symbol> was suggested instead, but I'm not 100% if that ever
became the preferred solution.

> There are other components which also struggle with duplicate symbols:
> ftrace, kprobes, BPF, etc.  It would be good to come up with a kallsyms
> solution that works for everybody.
> 
> Anyway, I was nodding along with the above cover letter until I got to
> the third paragraph.
> 
> A "built-in kernel module" is not actually a module, as it's built in to
> vmlinux.  I suspect the point is that if you rebuild with a different
> config, it might become a module.  But many other changes could also
> occur with a changed config, including changed inlining decisions and
> GCC IPA optimization function renaming, in which case the symbol might
> no longer exist with the new config.
> 
> Also I'm confused what it means for a symbol to be "used by multiple
> modules".  If the same TU or inline symbol is linked into two modules,
> it will be loaded twice at two different addresses, and the
> implementations could even differ.
> 
> It sounds like there are two problems being conflated:
> 
>   1) how to uniquely identify symbols in the current kernel
> 
>      For this, all we really need is file+sym.
> 
>      Or, enable -zunique-symbols in the linker.
> 
>   2) how to uniquely identify symbols across multiple kernels/configs
> 
>      This seems much trickier, as much can change across kernels and
>      configs, including compiler inlining and naming decisions, not to
>      mention actual code changes.
> 
> The problems are related, but distinct.
> 
> #2 seems significantly harder to implement properly.
> 
> Would solving #1 give you most of what you need?
> 
> Based on the difficulty of #2, it really needs a proper justification.
> I didn't see that in either of the patch sets.
> 
> Can you share more details about what specific problem needs solved and
> why?  And how this would be used?  Examples would be helpful.
> 
> The article linked to this brief explanation [1], but that doesn't
> clarify why "distinct notation used by users for things in named
> modules" would be important.
> 
> Is there a reason the user can't just use whatever notation is
> appropriate for their specific kernel?  Or, once we have #1, couldn't
> tooling do an intermediate translation?
> 
> [1] https://lwn.net/ml/linux-kernel/87h6z5wqlk.fsf@esperi.org.uk/
> 

-- 
Joe

