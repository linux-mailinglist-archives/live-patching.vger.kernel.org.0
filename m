Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D595B2AC7
	for <lists+live-patching@lfdr.de>; Fri,  9 Sep 2022 02:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiIIAHq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Sep 2022 20:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbiIIAHp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Sep 2022 20:07:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DE198D01;
        Thu,  8 Sep 2022 17:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8CnUe8YsCxH7jOeI9watXOlcGG2e1D+krl2jJdDsPKk=; b=EYgnrRin8PibVJ+ZEQZ5z6zTPP
        gq73HpWP2Ug2/e94NggkDzYdAchDB6ycog5O2RKJPa0biNITSw3g+ON1FyQL3aOqDmMXIW1AS1Pt6
        XlM9w5s1DFKUKd/Aq4w6S6yZ7180Oy1yoPjnR98K/3iGYwfSP+V5TE9jp0V9Fqfk6M94M8A5zPwee
        V8aJjx8UuFiwHlXA35Bze6iq3Gb6NQYS4/RmB+j6OPNwMEGLRZ9I9owrujr1+Ra3HjsUdDC3avGyg
        kM4JWpjc/0AZ7VyCOoaNlwnQRhwDJc6CGHAwxkvOAdVH09Zal4dQq2PFbsH9FOAMEvW7QNOEqkiDQ
        eRU91X4g==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oWRYZ-00A8Ew-Dv; Fri, 09 Sep 2022 00:07:39 +0000
Date:   Thu, 8 Sep 2022 17:07:39 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
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
        linux-modules@vger.kernel.org
Subject: Re: [PATCH 0/7] kallsyms: Optimizes the performance of lookup symbols
Message-ID: <YxqDyyVwVUnqc8B1@bombadil.infradead.org>
References: <20220908130936.674-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908130936.674-1-thunder.leizhen@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 08, 2022 at 09:09:29PM +0800, Zhen Lei wrote:
> Currently, to search for a symbol, we need to expand the symbols in
> 'kallsyms_names' one by one, and then use the expanded string for
> comparison. This is very slow.
> 
> In fact, we can first compress the name being looked up and then use
> it for comparison when traversing 'kallsyms_names'.
> 
> This patch series optimizes the performance of function kallsyms_lookup_name(),
> and function klp_find_object_symbol() in the livepatch module. Based on the
> test results, the performance overhead is reduced to 5%. That is, the
> performance of these functions is improved by 20 times.
> 
> To avoid increasing the kernel size in non-debug mode, the optimization is only
> for the case CONFIG_KALLSYMS_ALL=y.

WIthout having time yet to reveiw the implementation details, it would
seem this is an area we may want to test for future improvements easily,
so a selftest better yet a kunit test may be nice for this. Can you
write one so we can easily gather a simple metric for "how long does
this take"?

  Luis
