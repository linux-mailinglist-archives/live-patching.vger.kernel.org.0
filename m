Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D9D6BFC6A
	for <lists+live-patching@lfdr.de>; Sat, 18 Mar 2023 20:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjCRTaG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 18 Mar 2023 15:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjCRTaF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 18 Mar 2023 15:30:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13605BB0;
        Sat, 18 Mar 2023 12:30:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6635B60EEE;
        Sat, 18 Mar 2023 19:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99B9C4339C;
        Sat, 18 Mar 2023 19:29:59 +0000 (UTC)
Date:   Sat, 18 Mar 2023 15:29:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-modules@vger.kernel.org>
Subject: Re: [PATCH] kallsyms: Delete an unused parameter related to
 {module_}kallsyms_on_each_symbol()
Message-ID: <20230318152958.16055098@rorschach.local.home>
In-Reply-To: <20230308073846.1882-1-thunder.leizhen@huawei.com>
References: <20230308073846.1882-1-thunder.leizhen@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 8 Mar 2023 15:38:46 +0800
Zhen Lei <thunder.leizhen@huawei.com> wrote:

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 29baa97d0d53428..76caca8f496aaed 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -8391,8 +8391,7 @@ struct kallsyms_data {
>   * and returns 1 in case we resolved all the requested symbols,
>   * 0 otherwise.
>   */
> -static int kallsyms_callback(void *data, const char *name,
> -			     struct module *mod, unsigned long addr)
> +static int kallsyms_callback(void *data, const char *name, unsigned long addr)
>  {
>  	struct kallsyms_data *args = data;
>  	const char **sym;
> -- 

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
