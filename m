Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC598629278
	for <lists+live-patching@lfdr.de>; Tue, 15 Nov 2022 08:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiKOHa3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Nov 2022 02:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbiKOHa2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Nov 2022 02:30:28 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B5A1DDE4;
        Mon, 14 Nov 2022 23:30:27 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id cl5so22699554wrb.9;
        Mon, 14 Nov 2022 23:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m19Xg93KjBfSnHx4juiS3V4vDkrijASgcVGL6AJsgeU=;
        b=jttYtcUfxSV6czckQ6I0GYNmW3+5cbKBXHuCFB3OOcpYe2tO+vVwffONsp9C73KGsi
         B1uo4tLV5ey3GYFBpPbd5IvV9x8t/wIdc3LqwWGhqlRm1Hzh0n+vM2LDaJ3sOew3ZVhi
         mRAMZ/QDj+RtF3AFwsiM7rwNzI6zcFSHBwUQZXOLgrpKjnRenRfOARWXm0kmEGLfDyv8
         4pql44zHWHYqEsYWu/ICV9IXH7HGHJHpmKThrnnJFkAD0EglfujWgY2MpQqxfFom1tE6
         4RP2wugeT0om3RqiOs0W3MkXS6Cm56oxL4du+j1wOERaaAYwJiw0b/jpwkJvnJ3F/NR5
         g3ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m19Xg93KjBfSnHx4juiS3V4vDkrijASgcVGL6AJsgeU=;
        b=CgION4FMgy2lLWxt6HA8oeUyFgsc11M41Wbti+lAQ9+xpZXTfr2yJBbpGrC6HYfjwe
         O+Qky5yhWWDc5wceh3IYPa7lqzRGU3nsKyi9R+HHcEbzcyhEIvyzwxZEZoAKVsTroNTP
         WtyVSjwbKWRcKqfX2hnuUsPlKUUkjYa7U9OWZIordeNFcSnrCUJPxsSNIIOJzlSENfUA
         KzXHoQidPQ3+e0ezwYQTnkcXqY1qroGAG1NAwMteNfOF80MVnnmovlVK9FEdb8cGImOQ
         7/UlNOnRkhzRafsecTWunh6+GviNdDeXdwSMaHRiAfUszKTWUYGAEwjq/i3h9yF4NHqL
         FDMA==
X-Gm-Message-State: ANoB5pkOKj8qS9G0F3IBf1BlSgiYfCK05czC3nifK1Gnlpz+Utq9y3tB
        GfuAN+J5VfL1ralPelJQui8=
X-Google-Smtp-Source: AA0mqf4lhcp6QtUhs0G1JpeMHMO0JKn1zVvg1TdYhDWJYuT7eH5wK+ILKKvZNPTuJDDUkvMXM37asA==
X-Received: by 2002:a05:6000:51:b0:241:553e:5040 with SMTP id k17-20020a056000005100b00241553e5040mr9880616wrx.578.1668497426017;
        Mon, 14 Nov 2022 23:30:26 -0800 (PST)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id c17-20020adffb11000000b002417f35767asm8276863wrr.40.2022.11.14.23.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 23:30:25 -0800 (PST)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 15 Nov 2022 08:30:23 +0100
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Jiri Olsa <olsajiri@gmail.com>,
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
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v8 7/9] livepatch: Improve the search performance of
 module_kallsyms_on_each_symbol()
Message-ID: <Y3NADwGUIvfwnGTp@krava>
References: <20221102084921.1615-8-thunder.leizhen@huawei.com>
 <Y3HyrIwlZPYM8zYd@krava>
 <050b7513-4a20-75c7-0574-185004770329@huawei.com>
 <Y3IJ5GjrXBYDbfnA@krava>
 <ad637488-930e-33c1-558c-fc03d848afa8@huawei.com>
 <Y3IY6gzDtk1ze3u7@krava>
 <955eebae-0b36-d13f-0199-2f1b32af7da6@huawei.com>
 <Y3JB++KOXxMWWX35@krava>
 <Y3JivLcvbHNcIcSB@bombadil.infradead.org>
 <df46ad45-2de4-0300-4afa-5788463d712a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df46ad45-2de4-0300-4afa-5788463d712a@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 15, 2022 at 10:10:16AM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/11/14 23:46, Luis Chamberlain wrote:
> > On Mon, Nov 14, 2022 at 02:26:19PM +0100, Jiri Olsa wrote:
> >> I'll check on that, meanwhile if we could keep the module argument,
> >> that'd be great
> > 
> > As Leizhen suggested I could just drop patches:
> > 
> > 7/9 livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
> > 8/9 kallsyms: Delete an unused parameter related to kallsyms_on_each_symbol()
> > 
> > Then after the next kernel is released this can be relooked at.
> > If this is agreeable let me know.
> 
> I'm OK.

sounds good, thanks

jirka
