Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 600F317563A
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2020 09:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCBIp2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Mar 2020 03:45:28 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57577 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgCBIp2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Mar 2020 03:45:28 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0TrPMVk8_1583138724;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0TrPMVk8_1583138724)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Mar 2020 16:45:25 +0800
To:     jpoimboe@redhat.com
Cc:     live-patching@vger.kernel.org
From:   JeffleXu <jefflexu@linux.alibaba.com>
Subject: [help] Confusion on livepatch's per-task consistency model
Message-ID: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
Date:   Mon, 2 Mar 2020 16:45:24 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello guys,


I'm new to livepatch world and now I'm a little confused with livepatch's

per-task consistency model which is introduced by [1]. I've also readed the

discussion on mailing list [2], which introduces shadow variable to handle

data layout and semantic changes. But there's still some confusion with this

per-task consistency model.


According to the model, there will be scenario where old function and new

function can co-exist, though for a single thread, it sees either all new

functions or all old functions.


I can't understand why Vojtech said that 'old func processing new data' was

impossible. Assuming a scenario where a process calls func-A to submit a

work request (inserted into a global list), and then a kthread is 
responsible

for calling func-B to process all work requests in the list. What if 
this process

has finished the transition (sees new func-A) while kthread still sees 
the old func-B?

In this case, old func-B has to process new data. If there's some lock 
semantic

changes in func-A and func-B, then old func-B has no way identifying the 
shadow

variable labeled by new func-A.


Please tell me if I missed something, and any suggestions will be 
appreciated. ;)


Thanks.


[1] livepatch: change to a per-task consistency model

(https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.6-rc3&id=d83a7cb375eec21f04c83542395d08b2f6641da2)


[2] https://lkml.kernel.org/r/20141107140458.GA21774@suse.cz

