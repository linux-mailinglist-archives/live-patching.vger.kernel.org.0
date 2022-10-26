Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3910360E854
	for <lists+live-patching@lfdr.de>; Wed, 26 Oct 2022 21:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbiJZTG4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Oct 2022 15:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbiJZTGh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Oct 2022 15:06:37 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113AF141383;
        Wed, 26 Oct 2022 12:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r3Pfzq8iLf21/gz3vKU7KH69j7rAkB4oAHyVkIHhiQY=; b=xF+2rcJB7udh+J+Ag+JT79VckR
        5/aeywQviRtPSnZ1ya9NT5lSAPGHHA9rhIJHo+Mt4EvVqNvp16GSByh4l3YA9wr8mnJzJlGr0jCNb
        uc39VCS4doPpfNlfEzYYzd4AJkxMzm2sl++QAN6ALwLoz4CuzlvQH4V9bO9UxEPW/Mha+7kDNixxS
        aIPz0NPwzTOrk56hw0Un20+nzgGcVR3U7I5bS7KX7GDsvt+tKFrYomWjZehL+775+fzIPKyCRurCd
        l8ddecgsWb6qqaZy2vUq7BcVpJtQHOeWC3pdyvillVYqjLFfj8sFJnT2gwkfY8rwDK6pv0ikz65Js
        jjZd+1yQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1onlge-00Aer3-5w; Wed, 26 Oct 2022 19:03:36 +0000
Date:   Wed, 26 Oct 2022 12:03:36 -0700
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
Message-ID: <Y1mEiIvbld4SX1lx@bombadil.infradead.org>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
 <Y0/nEngJF6bbINEx@bombadil.infradead.org>
 <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
 <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
 <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
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

On Wed, Oct 26, 2022 at 02:44:36PM +0800, Leizhen (ThunderTown) wrote:
> On 2022/10/26 1:53, Luis Chamberlain wrote:
> > This answers how we don't use a hash table, the question was *should* we
> > use one?
> 
> I'm not the original author, and I can only answer now based on my understanding. Maybe
> the original author didn't think of the hash method, or he has weighed it out.
> 
> Hash is a good solution if only performance is required and memory overhead is not
> considered. Using hash will increase the memory size by up to "4 * kallsyms_num_syms +
> 4 * ARRAY_SIZE(hashtable)" bytes, kallsyms_num_syms is about 1-2 million.
> 
> Because I don't know what hash algorithm will be used, the cost of generating the
> hash value corresponding to the symbol name is unknown now. But I think it's gonna
> be small. But it definitely needs a simpler algorithm, the tool needs to implement
> the same hash algorithm.

For instance, you can look at evaluating if alloc_large_system_hash() would help.

  Luis
