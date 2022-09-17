Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E84D75BB711
	for <lists+live-patching@lfdr.de>; Sat, 17 Sep 2022 10:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIQIHw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 17 Sep 2022 04:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiIQIHv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 17 Sep 2022 04:07:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F704DB1C
        for <live-patching@vger.kernel.org>; Sat, 17 Sep 2022 01:07:48 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o20-20020a05600c4fd400b003b4a516c479so1133932wmq.1
        for <live-patching@vger.kernel.org>; Sat, 17 Sep 2022 01:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:to:from:date:from:to:cc:subject:date;
        bh=GFyHAzwXr730uhwdQiSNlgssWTGdDDZKeAK9yDoCuC0=;
        b=CgM3eiZEevmVv1FT3J03eCBUkH5eK84YGk1Y+U88ZaRNMsJVkc3SDSHL9dGzuWFaBu
         kz5jg3cFwOG31ztZ8Dhtr61KpperOlvXAvhbxIibi3X4A7iSnQvP6dWNm4ClgvcribDg
         o47bMRN1xMMxM3pCO8RPSY4tycuu82AdGsR+M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:to:from:date:x-gm-message-state:from
         :to:cc:subject:date;
        bh=GFyHAzwXr730uhwdQiSNlgssWTGdDDZKeAK9yDoCuC0=;
        b=4MUpRJe00QWMI5gieHeAh3X0iPGnh5IV9WPIas5LybmLdiCZKL3os6EMgKRXD4jCSe
         l2SBkUPkoPxaaytxYfvZtqD+rj0JLJxzNf9rToU9/W0aLeOKoqyVW8lMLYqrfheA721p
         t+DWarfhr5ryW7hdGiKTLgaHiR60Uz0D/Lyhi5tc5pakO5SXq8nioSkMMCmuvA/s7IVY
         CdGHxdNhggFr6vnOhTOLfG724uLUPGB76k3UjEVpifrlF9kzGht4gg2uhEHycvsne8jj
         QicIEzJHkzWmZHlATHE9VU1jPdowIvIt4wDb9oeMMP5tg/kEy61DD9lUNMTNIO2x26s9
         hjtQ==
X-Gm-Message-State: ACgBeo2e7l3EaKYTt5xO1yvO2Y4G7lkt/xH0B9HttTSzuJt1U71+z/r/
        VCl1HZHbRDvr4hjpEmwYqf8jWg==
X-Google-Smtp-Source: AA6agR62pl9C0D5FxdEANkkBx4K9fbVsk2ADSOwNLtlytmxLkb1EtZmKD1yK+H6CcGtDxTka7ZFg7A==
X-Received: by 2002:a05:600c:a46:b0:3a6:9c49:b751 with SMTP id c6-20020a05600c0a4600b003a69c49b751mr12960881wmq.169.1663402066990;
        Sat, 17 Sep 2022 01:07:46 -0700 (PDT)
Received: from [127.0.0.1] ([82.141.251.26])
        by smtp.gmail.com with ESMTPSA id k24-20020a05600c0b5800b003a502c23f2asm5081654wmr.16.2022.09.17.01.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Sep 2022 01:07:45 -0700 (PDT)
Date:   Sat, 17 Sep 2022 09:07:44 +0100
From:   Kees Cook <keescook@chromium.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 8/8] kallsyms: Add self-test facility
User-Agent: K-9 Mail for Android
In-Reply-To: <20220909130016.727-9-thunder.leizhen@huawei.com>
References: <20220909130016.727-1-thunder.leizhen@huawei.com> <20220909130016.727-9-thunder.leizhen@huawei.com>
Message-ID: <C889CF38-A80A-4DF6-9648-3B8947494CBC@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On September 9, 2022 2:00:16 PM GMT+01:00, Zhen Lei <thunder=2Eleizhen@hua=
wei=2Ecom> wrote:
>Add some test cases to test the function and performance of some kallsyms
>interfaces, such as kallsyms_lookup_name=2E It also calculates the
>compression rate of the kallsyms compression algorithm for the current
>symbol set=2E
>
>Start self-test automatically after system startup=2E

I wonder if this would be better implemented as a kunit test? Shouldn't be=
 too hard to convert=2E Take a look at things like lib/overflow_kunit=2Ec, =
etc=2E

-Kees

--=20
Kees Cook
