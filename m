Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01881D9A7E
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2020 16:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgESO6E (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 May 2020 10:58:04 -0400
Received: from sonic304-9.consmr.mail.bf2.yahoo.com ([74.6.128.32]:42269 "EHLO
        sonic304-9.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728725AbgESO6D (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 May 2020 10:58:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1589900282; bh=lMwnL/6WltFrTd0TmVnY+7WY/Sq+3khHK9hYAyAunB4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=XuSjVp+YteEaeyjsxBwu7muJmwJWcHdIJ7TXeY/JoonTVXNjfM/XHgdb0AnNybRceZ9s7K+OHoVnn8WtKZnmkn2lm2eB5WQARGEwcvAJ0ehkohkorHcxev95vnsZ4gj5rtRdRiwdkbNe4J5R8lshvrYZSZ8CjGi7gJa4ch4eCNTssDvoBBvGLGN4ecN9WagD5hoYGWWGIkLpY6AxsCjmgwcra4BJLUF350hSK0CjGAfSzh5QVcs05912sbdU1n1LYyI+c0jV2yBrveVdcuqTohw5KARg56QFl8UtkrtbzbTkn0UJVAKpAdHib3/cjk3f8VYLYrIxfVV6UR2ckrY/OA==
X-YMail-OSG: 2L.dEiwVM1kM2PyfeRABO3joJY3kri_iPCszGxmEzLi9X17PTROoLKmI9AOu5Sx
 74xeafwn1vkB2lCqVSOw1PWUp_VaIh8nbKPW9c.TuOEWsdYKCVkVWCcgj66hK7cSEyJqZHTM7EH0
 BYNpa6A4RF5Op.v7lkpFPC_o1_hzbsyIq_SnoXX3Y69Y4oDyTDfhZZ3_IYsEuIB0r8ak3NNC9qYw
 4Fcv6d4zbcWLBLyWnwqmzKGkXi3i6fveb0ZGf5_bpBK.U8j3nGfvNA2kvPxB6ZMsS_mxRykVUbmy
 jbvQhB3Fb2uVwxZzXp0BlVDOk_QwnpMkL4Z6Imai4UQpx9Vnw8hHdPBckRmGtznV8n_wnMNv8i_7
 Dg3PEUMGt7vD9HKkXKESeqNb62fNgRogjRwMSGYPYKn8upqqoz8hPUrUtiOqFFBlorHUb8QMzr6D
 MzTNGsOMTrVV1c9CMPAEDJyZBprEeRo.Vxo7mKpJf3Wd007IVPVdortb7wL_qguqWt0vwuHKdxQM
 zYosHHZooukR0z2D_trKfJu9KbbcH17_FCunjQ5X5psqlsGZZeugdKHxlsogYaLWWALVT9.TSuJK
 JG1moC5r.u086WWtD3dWQji4.PKj27aeiAefjNJLC5nV8lCm4jqY339PmD_4XMtBNI_DQe7sQyaP
 larUMsukw5P_Pq0M2Ya6.tqrzk5XxO8UMVEPyC_zGm4WV44Icm3Et9ZHeQrwo0AvCq1_KXdkyzwM
 EH1nV.xcjttSP3Lifs.Ba.DSLk52Tc8sj6BGosZuoqM6HK5PqPfhjaYDd0f5g29phk32WpHWbA8u
 FSXU1ezqBnFrLff7CCtJMyh0ZhmQXorm.jMPBebarKXwL4K34o2YwpawouUWMlylwxfq2RirCwtE
 PKB2N9nxxHgCVnirH6tjRd5GV.uSeWO2BS5KiNSMMJ_uJtjwnPW6EslEmo4tJkeTPEC6JU0delEa
 .vxg08EB06E.vs3X.UaKyEDiEnWnRraRv3UcvMYrxtsFD0ktPF8rbtf.zzhZHSXcY_XuL3yXni3k
 w9_otNKJbLerF9tmJhTv4giaosCIqUe8F.8wpvBpTguQVxzJcSZZKAnHji9ATKn2eWYXctdey0uf
 WNIYaXeLPo9vSjPRnZm2jfYKRpt0m9Y.PweuYz2xJ67_K7DTEVzB37WPIztJYKrLRpq89nwEJDnx
 GYzD5djYsZHIVxLhufUd06PvGfouDSxiJQg.9hjCN.OGQqxGwrp7eJX6V2sRI0zufn5fyGbLxTBA
 aFcspbooyxPCljeqh0WsLmMlX0bOtreEBpP_TOWQO2diI2GRKbA4y7rB3q5ySudUOA0auWqx1DYc
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Tue, 19 May 2020 14:58:02 +0000
Date:   Tue, 19 May 2020 14:57:58 +0000 (UTC)
From:   Rose Gordon <rosegordonor@gmail.com>
Reply-To: rosegordonor@gmail.com
Message-ID: <2088720139.1027951.1589900278769@mail.yahoo.com>
Subject: Greetings to you
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <2088720139.1027951.1589900278769.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15960 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Greetings to you,
I hope that this letter finds you in the best of health and spirit. My name is Rose Gordan, Please I kindly request for your attention, I have a very important business to discuss with you privately and in a much matured manner but i will give the details upon receipt of your response,

Thank you in advance!

Yours sincerely,
Rose.
