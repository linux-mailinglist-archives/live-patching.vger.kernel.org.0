Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A237604593
	for <lists+live-patching@lfdr.de>; Wed, 19 Oct 2022 14:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbiJSMmO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Oct 2022 08:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiJSMmC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Oct 2022 08:42:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AE828E26;
        Wed, 19 Oct 2022 05:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jwcgtkLkQiYMzUrJg+SlENzlyrsokEnI9G+nAnfhqaI=; b=INrCud5ry7N46NrgwulMwX+RO8
        xFy8PwVoYLCmGzxfB76R29fdn+OR80+OD3sjqToaNvrqxtMmIdDxVwe3dUZlrYEeVsSeL1H0nCFYT
        aIWdIQ/k8v7ZyvTJFDdymr86f2TJKY6glp3FH+zD/raymjZbOQi7N1P2JAbU1WPa6IOsn2OaMcWxI
        hYePDGaPHVUVqmI+iB4BnD//gODZ8wCFm37fXq0CTNXYOMrslb/8HecTlKiVE64Ul5bl7l6c7PTfV
        +lPyOvWpemkec4PzrA/xKmruYuNsFmMxkyJTE/fiOxbeBHMWc9yOzCzgsxTQIoyKNADY0ASsvPMbz
        XprsNabw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ol7lC-0019IU-72; Wed, 19 Oct 2022 12:01:22 +0000
Date:   Wed, 19 Oct 2022 05:01:22 -0700
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
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
Message-ID: <Y0/nEngJF6bbINEx@bombadil.infradead.org>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221017064950.2038-1-thunder.leizhen@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Oct 17, 2022 at 02:49:39PM +0800, Zhen Lei wrote:
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

Stupid question, is a hash table in order?

  Luis
