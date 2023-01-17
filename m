Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C61366E12C
	for <lists+live-patching@lfdr.de>; Tue, 17 Jan 2023 15:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjAQOrP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Jan 2023 09:47:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbjAQOrO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Jan 2023 09:47:14 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AD56A6C;
        Tue, 17 Jan 2023 06:47:12 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 939CD688A3;
        Tue, 17 Jan 2023 14:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673966831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+KmcDJ3VMYAKIgRCSMWLz60BmNCLcIoLMlIb31IIdg=;
        b=Yyeuba8Sn41i5l7DHG5FOkV9L3Jb2zofXMy5w/U42ojgqZeEP5baYXL4g/dFZBlT46TrDF
        zssj9x7LrekODEDZGjEgAirHmQM11WpSp8XaHTRgvV8lJfrAoOEz5k+9ty+HC0u9QxMdsu
        Av5lpu2BPFFpvTg5O7OPDv78SZMWL/c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673966831;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X+KmcDJ3VMYAKIgRCSMWLz60BmNCLcIoLMlIb31IIdg=;
        b=1Qt8sfGMaaEn8rqaJzLxBUigNExU7McMqhn+hh8wmGwpLDIt2Z0ub0UZxlbM5hj/0GQpXh
        YkuUHwPSx2regxAA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D16282C141;
        Tue, 17 Jan 2023 14:47:10 +0000 (UTC)
Date:   Tue, 17 Jan 2023 15:47:15 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jiri Olsa <jolsa@kernel.org>
cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCHv3 bpf-next 1/3] livepatch: Improve the search performance
 of module_kallsyms_on_each_symbol()
In-Reply-To: <20230116101009.23694-2-jolsa@kernel.org>
Message-ID: <alpine.LSU.2.21.2301171546520.24433@pobox.suse.cz>
References: <20230116101009.23694-1-jolsa@kernel.org> <20230116101009.23694-2-jolsa@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 16 Jan 2023, Jiri Olsa wrote:

> From: Zhen Lei <thunder.leizhen@huawei.com>
> 
> Currently we traverse all symbols of all modules to find the specified
> function for the specified module. But in reality, we just need to find
> the given module and then traverse all the symbols in it.
> 
> Let's add a new parameter 'const char *modname' to function
> module_kallsyms_on_each_symbol(), then we can compare the module names
> directly in this function and call hook 'fn' after matching. If 'modname'
> is NULL, the symbols of all modules are still traversed for compatibility
> with other usage cases.
> 
> Phase1: mod1-->mod2..(subsequent modules do not need to be compared)
>                 |
> Phase2:          -->f1-->f2-->f3
> 
> Assuming that there are m modules, each module has n symbols on average,
> then the time complexity is reduced from O(m * n) to O(m) + O(n).
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Acked-by: Song Liu <song@kernel.org>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
