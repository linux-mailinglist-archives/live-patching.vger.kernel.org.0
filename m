Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE3460D2CF
	for <lists+live-patching@lfdr.de>; Tue, 25 Oct 2022 19:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiJYRyI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Oct 2022 13:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbiJYRyH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Oct 2022 13:54:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CED6C7871;
        Tue, 25 Oct 2022 10:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Snq3KmyK7Ytjcm1GfrE+K6Gm9Itr4ZtEw1p7NmTsejY=; b=cLKIm7NQUNUYLqy2QECCgw1UGW
        ahdKs/XeI5MrFdEuseNPTmUDdyhJAoUEEspMwF5K+J5JoOGT4AM8g7Tudd1E7QjfVotI60sXsZGvy
        BOROQpIOE4HP0ZdRC//MwfHCB2yhcz3DQqJ6nqNdWk7uQ7gx7vvtTcZkAYAt1RArJuC/azVDrkaTv
        OyPdtR/2X4lsCKRuviH+BtkgqFBj3F7TbW+HNIN8K4VWXjF1Drq0KS5ySgE39DVYq85CcbWuT5lK1
        //1U0QOIfdusW4UqNFl3OTfgZkwvD2UFqU3k8nP0L8WzniPLJr5XJK6zyZZ72IxRnDmYLLgXrspAw
        1Ga1Ig2A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onO7d-006YOz-Us; Tue, 25 Oct 2022 17:53:53 +0000
Date:   Tue, 25 Oct 2022 10:53:53 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
Message-ID: <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
 <Y0/nEngJF6bbINEx@bombadil.infradead.org>
 <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 19, 2022 at 10:11:58PM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/10/19 20:01, Luis Chamberlain wrote:
> > On Mon, Oct 17, 2022 at 02:49:39PM +0800, Zhen Lei wrote:
> >> Currently, to search for a symbol, we need to expand the symbols in
> >> 'kallsyms_names' one by one, and then use the expanded string for
> >> comparison. This is very slow.
> >>
> >> In fact, we can first compress the name being looked up and then use
> >> it for comparison when traversing 'kallsyms_names'.
> >>
> >> This patch series optimizes the performance of function kallsyms_lookup_name(),
> >> and function klp_find_object_symbol() in the livepatch module. Based on the
> >> test results, the performance overhead is reduced to 5%. That is, the
> >> performance of these functions is improved by 20 times.
> > 
> > Stupid question, is a hash table in order?
> 
> No hash table.
> 
> All symbols are arranged in ascending order of address. For example: cat /proc/kallsyms
> 
> The addresses of all symbols are stored in kallsyms_addresses[], and names of all symbols
> are stored in kallsyms_names[]. The elements in these two arrays are in a one-to-one
> relationship. For any symbol, it has the same index in both arrays.
> 
> Therefore, when we look up a symbolic name based on an address, we use a binary lookup.
> However, when we look up an address based on a symbol name, we can only traverse array
> kallsyms_names[] in sequence. I think the reason why hash is not used is to save memory.

This answers how we don't use a hash table, the question was *should* we
use one?

  Luis
