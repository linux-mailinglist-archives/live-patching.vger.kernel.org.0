Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3676A1EE4D6
	for <lists+live-patching@lfdr.de>; Thu,  4 Jun 2020 14:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbgFDM4C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Jun 2020 08:56:02 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33338 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726003AbgFDM4C (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Jun 2020 08:56:02 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id C3FF38982D2650F15B66;
        Thu,  4 Jun 2020 20:55:57 +0800 (CST)
Received: from [127.0.0.1] (10.166.212.204) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Thu, 4 Jun 2020
 20:55:47 +0800
Subject: Re: [PATCH] module: make module symbols visible after init
To:     <linux-kernel@vger.kernel.org>, <live-patching@vger.kernel.org>
CC:     <chenwandun@huawei.com>, <xiexiuqi@huawei.com>,
        <bobo.shaobowang@huawei.com>, <huawei.libin@huawei.com>,
        <jeyu@kernel.org>, <jikos@kernel.org>
References: <20200603141200.17745-1-cj.chengjian@huawei.com>
From:   "chengjian (D)" <cj.chengjian@huawei.com>
Message-ID: <14e1413f-92a2-f228-e149-82d4fdbc0c0d@huawei.com>
Date:   Thu, 4 Jun 2020 20:55:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603141200.17745-1-cj.chengjian@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.166.212.204]
X-CFilter-Loop: Reflected
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi, Petr, Jessica and Miroslav

Thank you for your reply

On 2020/6/4 16:57, Petr Mladek wrote:
> On Wed 2020-06-03 14:12:00, Cheng Jian wrote:
>
> It is really handful that module symbols can be found already when
> the module is MODULE_STATE_COMING state. It is used by livepatching,
> ftrace, and maybe some other subsystems.

Yes, you are right, I missed this before.

There are many scenes that lookup the symbols of module when the module is

MODULE_STATE_COMING state.

in livepatch:

     klp_module_coming

-=> klp_write_object_relocations

-=> klp_resolve_symbols

-=> module_kallsyms_on_each_symbol

My patch is incorrect.

> The problem is that nobody is allowed to use (call) module symbols
> before mod->init() is called and the module is moved to
> MODULE_STATE_LIVE.
>
> By other words. Any code that calls module symbols before the module
> is fully initialized is buggy. The caller should get fixed,
> not the kallsyms side.
>
> Have you seen such a problem in the real life, please?
>
> Best Regards,
> Petr
>
> .


     Thank you very much.

         -- Cheng Jian.


