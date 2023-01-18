Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 685B5671013
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 02:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjARBfL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Jan 2023 20:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjARBfJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Jan 2023 20:35:09 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55934ED2D;
        Tue, 17 Jan 2023 17:35:07 -0800 (PST)
Received: from dggpemm500006.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NxSvm3jpbzJrTZ;
        Wed, 18 Jan 2023 09:33:40 +0800 (CST)
Received: from [10.174.178.55] (10.174.178.55) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 18 Jan 2023 09:35:03 +0800
Subject: Re: [PATCH v3] kallsyms: Remove the performance test from
 kallsyms_selftest.c
To:     Luis Chamberlain <mcgrof@kernel.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, <bpf@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-modules@vger.kernel.org>
References: <20230110130121.1279-1-thunder.leizhen@huawei.com>
 <Y8Hn9Bd7XFGkBnWO@bombadil.infradead.org>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <fc4cd660-b01b-c02b-7bfb-64606bd4a247@huawei.com>
Date:   Wed, 18 Jan 2023 09:34:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <Y8Hn9Bd7XFGkBnWO@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.55]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2023/1/14 7:23, Luis Chamberlain wrote:
> On Tue, Jan 10, 2023 at 09:01:21PM +0800, Zhen Lei wrote:
>> Suggested-by: Petr Mladek <pmladek@suse.com>
> 
> I've dropped this in favor of Nick's fix and pushed to Linus.

OK, great. This problem finally landed before the Chinese New Year.

> 
>   Luis
> .
> 

-- 
Regards,
  Zhen Lei
