Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 541D5647A8C
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 01:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiLIALc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Dec 2022 19:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbiLIALX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Dec 2022 19:11:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3882D8C443;
        Thu,  8 Dec 2022 16:11:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCDEBB826B8;
        Fri,  9 Dec 2022 00:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD02C433A0;
        Fri,  9 Dec 2022 00:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670544680;
        bh=11hbPktadPk8ZTaHVtNcO7qZWBpSovYEHzHUWGiyXqo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CIM1oYPfFXPHWuufe8LaPLz0FCCm0ywzj/7Yar3yepWJSAwwkq89REmwh6FJsrhMU
         fwzOmL7Pp0M3Z2s+rolMIplDun1Irlr0XHAcnKtsh/RgFPlFpyQ543Sr2hwN9QzZRU
         XxMB5hSJM6BZbN6r4rq/1gJ84H7JlPymJD0JBG5A1n4P8yScOKep3JqwFRPfMyDUhK
         DtRTZZe6M3ST6ZyH8UV4u4q4DDapUx+nI+pmCbbeNhCYo/WV0gL6Rv2GNWFABpgM38
         PW7iygS5CJ1zPKlp6M7k7MHxx8Y6Q33HEg3WuGnyrlJumv7qddMS+9CyAUmO2/qs0F
         nk/2y6HaB+10w==
Received: by mail-ej1-f52.google.com with SMTP id bj12so7771594ejb.13;
        Thu, 08 Dec 2022 16:11:20 -0800 (PST)
X-Gm-Message-State: ANoB5pkHGQ9yM1CHwAxncmfmci53+ZiYg1BCH0lqaplf1LYrhr6yl5IQ
        mRlGftjZRpWfeiUzl9VbScj1HCKy73A3avZNNDw=
X-Google-Smtp-Source: AA0mqf6Xui6OqVVtHrIdbpNfzYILwVySbQXlsoRnTchMt+jjUHNDufEowsUW3SkHeFXjYEjcs+4kpp9pmeBLt3xRrA0=
X-Received: by 2002:a17:906:2645:b0:781:d0c1:4434 with SMTP id
 i5-20020a170906264500b00781d0c14434mr78337672ejc.756.1670544678800; Thu, 08
 Dec 2022 16:11:18 -0800 (PST)
MIME-Version: 1.0
References: <20221207032304.2017-1-thunder.leizhen@huawei.com>
In-Reply-To: <20221207032304.2017-1-thunder.leizhen@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 8 Dec 2022 16:11:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4xZ-d7Yk0VLcym4UfFwzo6yd190hVSsiwNdSEzz9xeKA@mail.gmail.com>
Message-ID: <CAPhsuW4xZ-d7Yk0VLcym4UfFwzo6yd190hVSsiwNdSEzz9xeKA@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Call klp_match_callback() in
 klp_find_callback() to avoid code duplication
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Dec 6, 2022 at 7:25 PM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> The implementation of function klp_match_callback() is identical to the
> partial implementation of function klp_find_callback(). So call function
> klp_match_callback() in function klp_find_callback() instead of the
> duplicated code.
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Acked-by: Song Liu <song@kernel.org>
