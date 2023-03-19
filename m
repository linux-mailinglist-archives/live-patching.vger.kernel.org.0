Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91D66C04A2
	for <lists+live-patching@lfdr.de>; Sun, 19 Mar 2023 21:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCSUAJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 19 Mar 2023 16:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCSUAI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 19 Mar 2023 16:00:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98946193E5;
        Sun, 19 Mar 2023 12:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Mm5hAkLD4yLj0mE1mdGeckyZ6ya5GzFBRWzIacjhkDs=; b=GRfyPnZBO6s2GUbhAtXKTg4FOB
        JDsUoyrbN9te/DxcftSI/88lF9I8Qt1oIPRxO5Q/AZ4vOs5DKj/hGsFDivNYH6Xhu5/fzXk9e5A8E
        /eGobTH5eXNoNxS0r6XLb1/xX+wm7BE7kwLUD8uOv5bgQAlfZ0GVq0HSS9jP+j6B3rTYqAv72EkKq
        EfVjmE80y0tF0sX1nyb5py7XeTTNHwSazhX64DSuJwm6lpBcCcXVHZ5/r4/7Sq85m1ah6bfmW2dKD
        a/zXfLYp23Q3/QywKW9sOR8vE9YgV1i7ENlxsMAj5WMxxS3qiyWlhdlDnNdSpW16XkameiW3OqIGS
        fIP0+M9A==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pdzBS-007KV1-0R;
        Sun, 19 Mar 2023 19:59:14 +0000
Date:   Sun, 19 Mar 2023 12:59:14 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH] kallsyms: Delete an unused parameter related to
 {module_}kallsyms_on_each_symbol()
Message-ID: <ZBdpkk275nlVL6yd@bombadil.infradead.org>
References: <20230308073846.1882-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308073846.1882-1-thunder.leizhen@huawei.com>
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

On Wed, Mar 08, 2023 at 03:38:46PM +0800, Zhen Lei wrote:
> The parameter 'struct module *' in the hook function associated with
> {module_}kallsyms_on_each_symbol() is no longer used. Delete it.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Thanks, queued up on modules-next.

  Luis
