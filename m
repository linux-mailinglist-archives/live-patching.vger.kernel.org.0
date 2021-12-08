Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC3D46CA36
	for <lists+live-patching@lfdr.de>; Wed,  8 Dec 2021 02:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhLHBxO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Tue, 7 Dec 2021 20:53:14 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28284 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242904AbhLHBxO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Dec 2021 20:53:14 -0500
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4J80TP4L1CzQj7C
        for <live-patching@vger.kernel.org>; Wed,  8 Dec 2021 09:49:29 +0800 (CST)
Received: from dggpeml100010.china.huawei.com (7.185.36.14) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 09:49:42 +0800
Received: from dggpeml500011.china.huawei.com (7.185.36.84) by
 dggpeml100010.china.huawei.com (7.185.36.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 8 Dec 2021 09:49:41 +0800
Received: from dggpeml500011.china.huawei.com ([7.185.36.84]) by
 dggpeml500011.china.huawei.com ([7.185.36.84]) with mapi id 15.01.2308.020;
 Wed, 8 Dec 2021 09:49:41 +0800
From:   Hubin <hubin57@huawei.com>
To:     "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Some questions about arm64 live-patching support
Thread-Topic: Some questions about arm64 live-patching support
Thread-Index: Adfr1ck9byrWnOH/QvqttCYrXg/ApQ==
Date:   Wed, 8 Dec 2021 01:49:41 +0000
Message-ID: <75f1c581d61d48ec88925ebb4f83d7fd@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.66]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

Currently Linux lacks support for live patching in arm64, and recently we have some patches to help enable this feature.
But I still don't know how much gap do we have from finishing arm64 live-patching support.
So I just have some questions:
1. What do we need to implement to support aarch64 live-patching?
2. Is there any plan or roadmap for this support?
3. What can I do, if I want to contribute to enabling this feature?

Thanks
